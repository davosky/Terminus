# Graph Report - Terminus  (2026-08-16)

## Corpus Check
- 74 files · ~43,393 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 421 nodes · 414 edges · 96 communities (50 shown, 46 thin omitted)
- Extraction: 80% EXTRACTED · 19% INFERRED · 0% AMBIGUOUS · INFERRED: 80 edges (avg confidence: 0.86)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `327f1855`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Stack & Project Metadata|Stack & Project Metadata]]
- [[_COMMUNITY_User Model & Authorization|User Model & Authorization]]
- [[_COMMUNITY_Signature Upload & CarrierWave|Signature Upload & CarrierWave]]
- [[_COMMUNITY_Devise Auth & UserDashboard|Devise Auth & UserDashboard]]
- [[_COMMUNITY_Bin Scripts & Tooling|Bin Scripts & Tooling]]
- [[_COMMUNITY_Signature Download Routes|Signature Download Routes]]
- [[_COMMUNITY_CLAUDE.md Security & Conventions|CLAUDE.md Security & Conventions]]
- [[_COMMUNITY_Secure Headers & CSP Rationale|Secure Headers & CSP Rationale]]
- [[_COMMUNITY_Rails App Boot & Locales|Rails App Boot & Locales]]
- [[_COMMUNITY_Vehicle CRUD Icon Set|Vehicle CRUD Icon Set]]
- [[_COMMUNITY_Security & Test DB Isolation Rules|Security & Test DB Isolation Rules]]
- [[_COMMUNITY_Stimulus Flash Controller|Stimulus Flash Controller]]
- [[_COMMUNITY_Application Controllers|Application Controllers]]
- [[_COMMUNITY_Storage & Environment Configs|Storage & Environment Configs]]
- [[_COMMUNITY_Core Rails Configs|Core Rails Configs]]
- [[_COMMUNITY_Admin Users Namespace|Admin Users Namespace]]
- [[_COMMUNITY_Validator Fields Migration|Validator Fields Migration]]
- [[_COMMUNITY_Confirmator Fields Migration|Confirmator Fields Migration]]
- [[_COMMUNITY_User Signature Migration|User Signature Migration]]
- [[_COMMUNITY_Database Conventions & SQLi|Database Conventions & SQLi]]
- [[_COMMUNITY_Secrets & Env Vars|Secrets & Env Vars]]
- [[_COMMUNITY_CI & Bundler Audit|CI & Bundler Audit]]
- [[_COMMUNITY_Stimulus Controllers|Stimulus Controllers]]
- [[_COMMUNITY_Devise Italian Locale Fix|Devise Italian Locale Fix]]
- [[_COMMUNITY_Devise Layout & Logo|Devise Layout & Logo]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 47|Community 47]]
- [[_COMMUNITY_Community 50|Community 50]]
- [[_COMMUNITY_Community 51|Community 51]]
- [[_COMMUNITY_Community 52|Community 52]]
- [[_COMMUNITY_Community 53|Community 53]]
- [[_COMMUNITY_Community 54|Community 54]]
- [[_COMMUNITY_Community 55|Community 55]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 57|Community 57]]
- [[_COMMUNITY_Community 58|Community 58]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 60|Community 60]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 62|Community 62]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]
- [[_COMMUNITY_Community 66|Community 66]]
- [[_COMMUNITY_Community 67|Community 67]]
- [[_COMMUNITY_Community 68|Community 68]]
- [[_COMMUNITY_Community 69|Community 69]]
- [[_COMMUNITY_Community 70|Community 70]]
- [[_COMMUNITY_Community 71|Community 71]]
- [[_COMMUNITY_Community 72|Community 72]]
- [[_COMMUNITY_Community 73|Community 73]]
- [[_COMMUNITY_Community 74|Community 74]]
- [[_COMMUNITY_Community 75|Community 75]]
- [[_COMMUNITY_Community 77|Community 77]]
- [[_COMMUNITY_Community 78|Community 78]]
- [[_COMMUNITY_Community 79|Community 79]]
- [[_COMMUNITY_Community 80|Community 80]]
- [[_COMMUNITY_Community 81|Community 81]]
- [[_COMMUNITY_Community 82|Community 82]]
- [[_COMMUNITY_Community 83|Community 83]]
- [[_COMMUNITY_Community 84|Community 84]]
- [[_COMMUNITY_Community 85|Community 85]]
- [[_COMMUNITY_Community 86|Community 86]]
- [[_COMMUNITY_Community 87|Community 87]]
- [[_COMMUNITY_Community 88|Community 88]]
- [[_COMMUNITY_Community 89|Community 89]]
- [[_COMMUNITY_Community 90|Community 90]]

## God Nodes (most connected - your core abstractions)
1. `CLAUDE.md — Guida per Claude Code` - 23 edges
2. `User` - 13 edges
3. `ApplicationPolicy#admin?` - 13 edges
4. `VehiclesController` - 11 edges
5. `ApplicationPolicy` - 10 edges
6. `Admin::UsersController#download_signature` - 10 edges
7. `UsersController` - 9 edges
8. `Best Practice di Sicurezza Chiave in Ruby on Rails` - 9 edges
9. `users table schema` - 9 edges
10. `CarrierwaveField#url` - 9 edges

## Surprising Connections (you probably didn't know these)
- `Italian User Attribute Translations` --references--> `UserDashboard::ATTRIBUTE_TYPES`  [INFERRED]
  config/locales/it.yml → app/dashboards/user_dashboard.rb
- `Security Audit Performed and Documented (secure_headers/CSP added as a result)` --conceptually_related_to--> `force_ssl / ssl_options Configuration`  [INFERRED]
  CLAUDE.md → config/environments/production.rb
- `Italian User Attribute Translations` --references--> `User Model`  [INFERRED]
  config/locales/it.yml → app/models/user.rb
- `User` --shares_data_with--> `users table schema`  [INFERRED]
  app/models/user.rb → db/schema.rb
- `User` --shares_data_with--> `DeviseCreateUsers`  [INFERRED]
  app/models/user.rb → db/migrate/20260815090539_devise_create_users.rb

## Hyperedges (group relationships)
- **Vehicle CRUD action icon set (index/show/new/edit/destroy)** —  [INFERRED 0.85]

## Communities (96 total, 46 thin omitted)

### Community 0 - "Stack & Project Metadata"
Cohesion: 0.07
Nodes (26): Stack Tecnico, LICENCE (Bilingual MIT License), README, README English Translation Section, browserslist, dependencies, autoprefixer, bootstrap (+18 more)

### Community 1 - "User Model & Authorization"
Cohesion: 0.14
Nodes (11): Admin::ApplicationController#authenticate_admin, ApplicationController#user_not_authorized, db/seeds.rb admin user seed, :user FactoryBot factory, User model spec, User, ApplicationPolicy#admin?, ApplicationPolicy (+3 more)

### Community 2 - "Signature Upload & CarrierWave"
Cohesion: 0.12
Nodes (23): Admin::UsersController#download_signature, Admin::UsersController#resource_params, Admin::UsersController#send_uploaded_file, Devise Routes for Users, UserDashboard, UserDashboard#display_resource, UserDashboard, users table schema (+15 more)

### Community 3 - "Devise Auth & UserDashboard"
Cohesion: 0.22
Nodes (6): UsersController, Download Confirmator Signature Route, Download Validator Signature Route, UserDashboard::ATTRIBUTE_TYPES, AddInstituteAndOfficeToUsers, AddInstituteAndOfficeToUsers Migration

### Community 4 - "Bin Scripts & Tooling"
Cohesion: 0.20
Nodes (14): bin/brakeman Runner Script, bin/bundler-audit Runner Script, bin/ci Runner Script, bin/dev Server Script, bin/docker-entrypoint Script, bin/rails CLI Script, bin/rubocop Runner Script, bin/setup Script (+6 more)

### Community 5 - "Signature Download Routes"
Cohesion: 0.13
Nodes (8): Download Signature Route, CarrierwaveField, CarrierwaveField#filename, CarrierwaveField#uploader, CarrierwaveField#url, ConfirmatorSignatureUploader, UserSignatureUploader, ValidatorSignatureUploader

### Community 6 - "CLAUDE.md Security & Conventions"
Cohesion: 0.29
Nodes (10): Autenticazione e Autorizzazione Robuste, Gem Principali, Graphify Knowledge Graph Setup, Terminus Amministrazione Spec, Costruzione dell'Applicazione Terminus, Terminus Autenticazione Spec, Terminus Autorizzazione Spec, Terminus Database Spec (+2 more)

### Community 7 - "Secure Headers & CSP Rationale"
Cohesion: 0.29
Nodes (8): Security Audit Performed and Documented (secure_headers/CSP added as a result), force_ssl / ssl_options Configuration, Rationale: Rails HSTS emission disabled because secure_headers now owns the HSTS header, Secure Headers Initializer, Secure Cookie Flags Configuration, Content-Security-Policy Configuration, HSTS Header Configuration (production-only), Rationale: CSP style-src allows unsafe-inline for Bootstrap data-URI SVGs and Rails default error pages

### Community 8 - "Rails App Boot & Locales"
Cohesion: 0.25
Nodes (8): Terminus::Application, Boot Configuration, Environment Loader, Application Routes, Devise Initializer, Filter Parameter Logging Initializer, Devise English Locale, English Locale

### Community 9 - "Vehicle CRUD Icon Set"
Cohesion: 0.25
Nodes (8): Multi-stop Gradient Palette (yellow/orange, pink/blue/purple), Vehicles Destroy Icon, Vehicles Edit Icon (SVG), Vehicles Index Icon (Car Illustration SVG), Vehicles "New" Action Icon (SVG), Multi-color Gradient Palette (pink/blue/purple/orange-yellow), Vehicles Show Icon (SVG), Vehicle Model/Resource

### Community 10 - "Security & Test DB Isolation Rules"
Cohesion: 0.33
Nodes (6): Protezione CSRF, Dev DB Credentials Redacted from NOTA BENE, Best Practice di Sicurezza per Ruby on Rails, Sicurezza (Project Conventions), Test/Development Database Isolation Rule, Regole per i Test

### Community 12 - "Application Controllers"
Cohesion: 0.31
Nodes (3): ApplicationController, ApplicationController, HomeController

### Community 13 - "Storage & Environment Configs"
Cohesion: 0.50
Nodes (4): Active Storage Config, Development Environment Config, Production Environment Config, Test Environment Config

### Community 14 - "Core Rails Configs"
Cohesion: 0.67
Nodes (3): Action Cable Config, Database Config, Puma Server Config

### Community 15 - "Admin Users Namespace"
Cohesion: 0.67
Nodes (3): Admin::UsersController, Admin Root Route, Admin Namespace Users Resources

### Community 79 - "Community 79"
Cohesion: 0.04
Nodes (48): ❌ Anti-Pattern da Evitare, Approccio: Test-first quando possibile, Approfondimento: Brakeman, Approfondimento: bundler-audit, 🔑 Best Practice Essenziali di Sicurezza per Ruby on Rails, Checklist delle Best Practice di Sicurezza, CLAUDE.md — Guida per Claude Code, code:bash (Ruby:        >= 4.0.1) (+40 more)

### Community 80 - "Community 80"
Cohesion: 0.06
Nodes (33): 1. Protezione dall'SQL Injection, 2. Mitigazione del Cross-Site Scripting (XSS), 3. Gestione Sicura di Segreti, Credenziali e Dati di Configurazione Sensibili, 4. Corretta Gestione delle Sessioni e Cookie Sicuri, 5. Strategie di Protezione contro il Cross-Site Request Forgery (CSRF), 6. Upload di File Sicuri e Gestione degli Allegati, 7. Autenticazione e Autorizzazione Robuste, 8. Monitoraggio e Audit di Sicurezza Continui (+25 more)

### Community 83 - "Community 83"
Cohesion: 0.18
Nodes (10): Avvio del progetto, code:bash (bin/setup   # setup iniziale (dipendenze, database)), code:bash (bin/setup   # initial setup (dependencies, database)), Getting started, License, Licenza, Stack tecnico, Tech stack (+2 more)

### Community 84 - "Community 84"
Cohesion: 0.33
Nodes (6): code:text (Aggiungi la possibilità per gli utenti di commentare i Post.), Come fare una richiesta efficace, Cose che Claude Code può fare autonomamente, Cose su cui chiedere conferma prima, Esempio di prompt efficace, 🚀 Workflow con Claude Code

### Community 85 - "Community 85"
Cohesion: 0.40
Nodes (4): Copyright (c) 2026, Davo Davosky - The Davosky Connection, English, Italiano

## Ambiguous Edges - Review These
- `Action Cable Config` → `Database Config`  [AMBIGUOUS]
  config/cable.yml · relation: conceptually_related_to

## Knowledge Gaps
- **157 isolated node(s):** `name`, `private`, `esbuild`, `build`, `build:css:compile` (+152 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **46 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `Action Cable Config` and `Database Config`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `CLAUDE.md — Guida per Claude Code` connect `Community 79` to `Community 80`, `Community 84`?**
  _High betweenness centrality (0.036) - this node is a cross-community bridge._
- **Why does `User` connect `User Model & Authorization` to `Community 82`, `Signature Upload & CarrierWave`?**
  _High betweenness centrality (0.031) - this node is a cross-community bridge._
- **Why does `Best Practice di Sicurezza Chiave in Ruby on Rails` connect `Community 80` to `Community 79`?**
  _High betweenness centrality (0.025) - this node is a cross-community bridge._
- **Are the 8 inferred relationships involving `User` (e.g. with `.owner?()` and `Scope`) actually correct?**
  _`User` has 8 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `ApplicationPolicy#admin?` (e.g. with `User` and `Admin::ApplicationController#authenticate_admin`) actually correct?**
  _`ApplicationPolicy#admin?` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `name`, `private`, `esbuild` to the rest of the system?**
  _165 weakly-connected nodes found - possible documentation gaps or missing edges._