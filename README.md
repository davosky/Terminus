# Terminus

Terminus è un'applicazione Web Gestionale  
che gestisce:

- Rimborsi Spese
- Richieste Rimborsi Spese
- Assenze
  - Ferie
  - Richieste Ferie
  - Ferie Orarie
  - Richiesta Ferie Orarie
  - Permessi
  - Richiesta Permessi
  - Malattia

## Stack tecnico

- Ruby on Rails 8, PostgreSQL
- Hotwire (Turbo + Stimulus), Tailwind.css
- Devise (autenticazione via username) e Pundit (autorizzazione)
- RSpec, FactoryBot e Capybara per i test

## Avvio del progetto

```bash
bin/setup   # setup iniziale (dipendenze, database)
bin/dev     # avvia Rails e il watcher CSS (Tailwind)
```

L'applicazione richiede le variabili d'ambiente `DATABASE_HOST`,
`DATABASE_USER`, `DATABASE_PASSWORD` e `SECRET_KEY_BASE` (vedi `.env`,
gestite tramite `dotenv-rails`).

## Licenza

Distribuito sotto licenza MIT. Vedi [LICENCE.md](LICENCE.md).
