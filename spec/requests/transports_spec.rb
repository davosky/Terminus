require 'rails_helper'

RSpec.describe "Transports", type: :request do
  let(:user) { create(:user) }
  let!(:transport) { create(:transport, user: user, transport_name: "Treno", transport_position: 3) }
  let!(:locked) { create(:transport, :locked, user: user, transport_name: "Veicolo Privato", transport_position: 1) }
  let!(:foreign) { create(:transport, transport_name: "Aereo altrui") }

  def sign_in_as(account)
    post user_session_path, params: { user: { username: account.username, password: account.password } }
  end

  context "quando l'utente non è autenticato" do
    it "reindirizza al login" do
      get transports_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "quando l'utente è autenticato" do
    before { sign_in_as(user) }

    it "elenca solo i propri trasporti, in ordine di posizione" do
      get transports_path
      expect(response.body).to match(/Veicolo Privato.*Treno/m)
      expect(response.body).not_to include("translation_missing")
      expect(response.body).not_to include("Aereo altrui")
    end

    it "vede il dropdown Utility con la voce Trasporti" do
      get root_path
      expect(response.body).to include("Utility", %(href="#{transports_path}"))
    end

    it "apre new, show, edit e confirm_destroy dentro la finestra modale" do
      [ new_transport_path, transport_path(transport), edit_transport_path(transport),
        confirm_destroy_transport_path(transport) ].each do |path|
        get path
        expect(response.body).to include('<turbo-frame id="modal">', "<dialog")
        expect(response.body).not_to include("translation_missing")
      end
    end

    it "usa la misura unica .btn per tutti i bottoni fuori dalla navbar" do
      [ new_transport_path, edit_transport_path(transport), confirm_destroy_transport_path(transport) ].each do |path|
        get path
        buttons = css_select("button") - css_select("nav button")
        expect(buttons).not_to be_empty
        expect(buttons).to all(satisfy { |button| button["class"].to_s.split.include?("btn") })
      end
    end

    it "crea un trasporto proprio e non protetto" do
      post transports_path, params: { transport: { transport_name: "Taxi", transport_position: 4, locked: true } }
      expect(response).to redirect_to(transports_path)
      expect(user.transports.find_by(transport_name: "Taxi")).to have_attributes(transport_position: 4, locked: false)
    end

    it "mostra gli errori quando i dati non sono validi" do
      post transports_path, params: { transport: { transport_name: "", transport_position: 4 } }
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("<dialog", 'role="alert"')
    end

    it "modifica un proprio trasporto" do
      patch transport_path(transport), params: { transport: { transport_name: "Treno regionale" } }
      expect(transport.reload.transport_name).to eq("Treno regionale")
    end

    it "chiede conferma prima di eliminare" do
      get confirm_destroy_transport_path(transport)
      expect(response.body).to include("Stai per eliminare definitivamente il trasporto", "Treno", "Annulla")
      expect(Transport.exists?(transport.id)).to be(true)
    end

    it "elimina un proprio trasporto" do
      delete transport_path(transport)
      expect(response).to redirect_to(transports_path)
      expect(Transport.exists?(transport.id)).to be(false)
    end

    it "non raggiunge i trasporti degli altri utenti" do
      [ -> { get transport_path(foreign) }, -> { patch transport_path(foreign), params: { transport: { transport_name: "X" } } },
        -> { delete transport_path(foreign) } ].each do |request|
        request.call
        expect(response).to have_http_status(:not_found)
      end
      expect(foreign.reload.transport_name).to eq("Aereo altrui")
    end

    it "non può modificare né eliminare un trasporto protetto" do
      [ -> { patch transport_path(locked), params: { transport: { transport_name: "X" } } },
        -> { delete transport_path(locked) } ].each do |request|
        request.call
        expect(response).to redirect_to(root_path)
      end
      expect(locked.reload.transport_name).to eq("Veicolo Privato")
    end

    it "vede l'avviso di record di sistema al posto del form e della conferma" do
      [ edit_transport_path(locked), confirm_destroy_transport_path(locked) ].each do |path|
        get path
        expect(response.body).to include("<dialog", "Record di Sistema non modificabile")
        expect(response.body).not_to include("transport[transport_name]", %(action="#{transport_path(locked)}"))
      end
    end

    it "non vede l'avviso sui trasporti normali" do
      get confirm_destroy_transport_path(transport)
      expect(response.body).not_to include("Record di Sistema non modificabile")
    end
  end

  context "quando l'utente è amministratore" do
    let(:user) { create(:user, :admin) }

    before { sign_in_as(user) }

    it "non può modificare né eliminare un trasporto protetto dalle pagine normali" do
      patch transport_path(locked), params: { transport: { transport_name: "Auto propria" } }
      delete transport_path(locked)
      expect(locked.reload.transport_name).to eq("Veicolo Privato")
    end

    it "vede l'avviso di record di sistema quando prova a eliminarlo" do
      get confirm_destroy_transport_path(locked)
      expect(response.body).to include("Record di Sistema non modificabile")
    end

    it "può eliminarlo da Madmin" do
      delete madmin_transport_path(locked)
      expect(Transport.exists?(locked.id)).to be(false)
    end

    it "non vede i trasporti degli altri nelle pagine normali" do
      get transport_path(foreign)
      expect(response).to have_http_status(:not_found)
    end
  end
end
