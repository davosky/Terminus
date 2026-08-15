# Terminus

Terminus è un'applicazione web per la gestione di rimborsi spere ed assenze

## Stack tecnico

- Ruby on Rails 8, PostgreSQL
- Hotwire (Turbo + Stimulus), Bootstrap + Bootswatch Lumen
- Devise (autenticazione via username) e Pundit (autorizzazione)
- Administrate come pannello di amministrazione
- RSpec, FactoryBot e Capybara per i test

## Avvio del progetto

```bash
bin/setup   # setup iniziale (dipendenze, database)
bin/dev     # avvia Rails, il watcher JS (esbuild) e quello CSS (Sass)
```

L'applicazione richiede le variabili d'ambiente `DATABASE_HOST`,
`DATABASE_USER`, `DATABASE_PASSWORD` e `SECRET_KEY_BASE` (vedi `.env`,
gestite tramite `dotenv-rails`).

## Licenza

Distribuito sotto licenza **MIT**. Vedi [LICENCE.md](LICENCE.md).

---

# Terminus (English)

Terminus is a web application for managing expense reimbursements and absences.

## Tech stack

- Ruby on Rails 8, PostgreSQL
- Hotwire (Turbo + Stimulus), Bootstrap + Bootswatch Lumen
- Devise (username-based authentication) and Pundit (authorization)
- Administrate as the admin panel
- RSpec, FactoryBot and Capybara for testing

## Getting started

```bash
bin/setup   # initial setup (dependencies, database)
bin/dev     # starts Rails, the JS watcher (esbuild) and the CSS watcher (Sass)
```

The application requires the `DATABASE_HOST`, `DATABASE_USER`,
`DATABASE_PASSWORD` and `SECRET_KEY_BASE` environment variables (see `.env`,
managed via `dotenv-rails`).

## License

Distributed under the **MIT** license. See [LICENCE.md](LICENCE.md).
