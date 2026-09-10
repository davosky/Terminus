require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#form_label_class, #form_hr_class, #form_submit_accent" do
    it "usa l'accento verde in creazione" do
      allow(helper).to receive(:action_name).and_return("new")

      expect(helper.form_label_class).to eq("form-label text-success fs-5 fw-bold fst-italic")
      expect(helper.form_hr_class).to eq("text-success")
      expect(helper.form_submit_accent).to eq("btn btn-success")
    end

    it "usa l'accento arancione in modifica" do
      allow(helper).to receive(:action_name).and_return("edit")

      expect(helper.form_label_class).to eq("form-label text-warning fs-5 fw-bold fst-italic")
      expect(helper.form_hr_class).to eq("text-warning")
      expect(helper.form_submit_accent).to eq("btn btn-warning")
    end

    it "ripiega sui colori neutri per le altre azioni" do
      allow(helper).to receive(:action_name).and_return("show")

      expect(helper.form_label_class).to eq("form-label fs-5 fw-bold fst-italic")
      expect(helper.form_hr_class).to eq("text-primary")
      expect(helper.form_submit_accent).to eq("btn btn-primary")
    end
  end

  describe "#form_submit_label" do
    {
      vehicle: "Veicolo",
      transport: "Trasporto",
      reason: "Motivo Missione",
      path: "Percorso",
      place: "Luogo",
      structure: "Struttura",
      mission_request: "Richiesta Missione",
      reimbursement: "Rimborso Spese"
    }.each do |factory, label|
      it "dice 'Crea #{label}' e 'Aggiorna #{label}'" do
        record = build_stubbed(factory)

        allow(helper).to receive(:action_name).and_return("new")
        expect(helper.form_submit_label(record)).to eq("Crea #{label}")

        allow(helper).to receive(:action_name).and_return("edit")
        expect(helper.form_submit_label(record)).to eq("Aggiorna #{label}")
      end
    end

    it "ripiega su 'Salva' per le altre azioni" do
      allow(helper).to receive(:action_name).and_return("show")

      expect(helper.form_submit_label(build_stubbed(:vehicle))).to eq("Salva")
    end
  end

  describe "#stored_mode_checked?" do
    it "è vero per un record nuovo" do
      expect(helper.stored_mode_checked?(MissionRequest.new)).to be true
    end

    it "segue la presenza del motivo su un record esistente" do
      expect(helper.stored_mode_checked?(build_stubbed(:mission_request))).to be true
      expect(helper.stored_mode_checked?(build_stubbed(:mission_request, :free_fields))).to be false
    end
  end
end
