# Terminus

---

*Nome dell'applicazione:* **Terminus**, gestione rimborsi spese ed assenze.

*Scopo dell'applicazione:* Gestire i rimborsi spese ed assenze dei dipendenti.

- database:
  - RDBMS: Postgresql >= 18
  - database development: terminus_development
  - database test: terminus_test
  - usa dotenv-rails per gestire gli accessi ai database
- interfaccia grafica:
  - framework front-end: Bootstrap >= 5.2 (<https://getbootstrap.com/docs/5.2/getting-started/introduction/>)
  - personalizzazione:  Bootswatch  con un tema chiaro (<https://bootswatch.com/lumen/>)
  - interfaccia mobile first ( **gli utenti devono poter operare comodamente da telefonino** )
- javascript
  - bundler: ESbuild
  - preferire la creazione di controller Stimulus per qualsiasi codice javascript
- autenticazione
  - autenticazione usando la gemma Devise
  - il campo principale per l'autenticazione deve essere **username** e non email
  - ottimizzare Devise in modo che sia compatibile con tutbo-rails
- amministrazione
  - usare la gemma Administrate
  - per ogni modello creato viene creato automaticamente un pannello corrispondente in Administrate
- autorizzazione
  - utillizzare la gemma Pundit per gestire le autorizzazioni degli utenti
  - l'utente con il flag **admin = true** può fare qualsiasi cosa ed ha i permessi più alti

## Disposizione dell'interfaccia principale ad accesso non avvenuto

Una pagina unica con al centro il logo dell'applicazione e una card dove sono presenti l'inserimento del nome-utente e della password.

## Disposizione dell'interfaccia principale ad accesso avvenuto

1. Ottimizzare la vista per le device mobili prima e poi per schermi da desktop pc
2. creazione degli utenti
   - creare un modello User con devise con i seguenti campi:
     - username: string (campo principale per l'autenticazione che deve essere indicizzato)
     - first_name:string
     - last_name:string
     - gender:string
     - region:string
     - province:string
     - category:string
     - admin:boolean
     - manager:boolean
     - regular:boolean
   - creare un primo utente amministratore con i seguenti dati
     - username:
     - password:
     - password_confirmation:
     - first_name:Davo
     - last_name:Davosky
     - gender:M
     - region:FVG
     - province:FVG
     - category:CGIL
     - admin:true
     - manager:false
     - regular:false
   - creare le views di devise

---

### NOTA BENE

i database **terminus_development** e **terminus_test** sono già stati creati e sono subito utilizzabili,
