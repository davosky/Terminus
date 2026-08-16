# Graph Report - .  (2026-08-16)

## Corpus Check
- 5 files · ~42,376 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 249 nodes · 233 edges · 79 communities (43 shown, 36 thin omitted)
- Extraction: 66% EXTRACTED · 34% INFERRED · 0% AMBIGUOUS · INFERRED: 79 edges (avg confidence: 0.86)
- Token cost: 0 input · 0 output

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

## God Nodes (most connected - your core abstractions)
1. `ApplicationPolicy#admin?` - 13 edges
2. `User` - 12 edges
3. `Admin::UsersController#download_signature` - 10 edges
4. `users table schema` - 9 edges
5. `CarrierwaveField#url` - 9 edges
6. `Costruzione dell'Applicazione Terminus` - 7 edges
7. `ValidatorSignatureUploader` - 7 edges
8. `ConfirmatorSignatureUploader` - 7 edges
9. `UserSignatureUploader` - 7 edges
10. `scripts` - 6 edges

## Surprising Connections (you probably didn't know these)
- `Italian User Attribute Translations` --references--> `User Model`  [INFERRED]
  config/locales/it.yml → app/models/user.rb
- `Italian User Attribute Translations` --references--> `UserDashboard::ATTRIBUTE_TYPES`  [INFERRED]
  config/locales/it.yml → app/dashboards/user_dashboard.rb
- `Security Audit Performed and Documented (secure_headers/CSP added as a result)` --conceptually_related_to--> `force_ssl / ssl_options Configuration`  [INFERRED]
  CLAUDE.md → config/environments/production.rb
- `User` --shares_data_with--> `users table schema`  [INFERRED]
  app/models/user.rb → db/schema.rb
- `User` --shares_data_with--> `DeviseCreateUsers`  [INFERRED]
  app/models/user.rb → db/migrate/20260815090539_devise_create_users.rb

## Hyperedges (group relationships)
- **Vehicle CRUD action icon set (index/show/new/edit/destroy)** —  [INFERRED 0.85]

## Communities (79 total, 36 thin omitted)

### Community 0 - "Stack & Project Metadata"
Cohesion: 0.08
Nodes (25): Stack Tecnico, LICENCE (Bilingual MIT License), README, README English Translation Section, browserslist, dependencies, autoprefixer, bootstrap (+17 more)

### Community 1 - "User Model & Authorization"
Cohesion: 0.14
Nodes (10): Admin::ApplicationController#authenticate_admin, ApplicationController#user_not_authorized, db/seeds.rb admin user seed, :user FactoryBot factory, User model spec, User, ApplicationPolicy#admin?, Scope (+2 more)

### Community 2 - "Signature Upload & CarrierWave"
Cohesion: 0.20
Nodes (12): Admin::UsersController#download_signature, Admin::UsersController#resource_params, Admin::UsersController#send_uploaded_file, content_type_allowlist(), extension_allowlist(), Italian User Attribute Translations, User mount_uploader confirmator_signature, User mount_uploader user_signature (+4 more)

### Community 3 - "Devise Auth & UserDashboard"
Cohesion: 0.14
Nodes (11): Devise Routes for Users, UserDashboard, UserDashboard#display_resource, users table schema, DeviseCreateUsers, AddConfirmatorFieldsToUsers Migration, AddInstituteAndOfficeToUsers Migration, AddUserSignatureToUsers Migration (+3 more)

### Community 4 - "Bin Scripts & Tooling"
Cohesion: 0.20
Nodes (14): bin/brakeman Runner Script, bin/bundler-audit Runner Script, bin/ci Runner Script, bin/dev Server Script, bin/docker-entrypoint Script, bin/rails CLI Script, bin/rubocop Runner Script, bin/setup Script (+6 more)

### Community 5 - "Signature Download Routes"
Cohesion: 0.21
Nodes (8): UsersController, Download Confirmator Signature Route, Download Signature Route, Download Validator Signature Route, UserDashboard::ATTRIBUTE_TYPES, CarrierwaveField#filename, CarrierwaveField#uploader, CarrierwaveField#url

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

### Community 13 - "Storage & Environment Configs"
Cohesion: 0.50
Nodes (4): Active Storage Config, Development Environment Config, Production Environment Config, Test Environment Config

### Community 14 - "Core Rails Configs"
Cohesion: 0.67
Nodes (3): Action Cable Config, Database Config, Puma Server Config

### Community 15 - "Admin Users Namespace"
Cohesion: 0.67
Nodes (3): Admin::UsersController, Admin Root Route, Admin Namespace Users Resources

## Ambiguous Edges - Review These
- `Action Cable Config` → `Database Config`  [AMBIGUOUS]
  config/cable.yml · relation: conceptually_related_to

## Knowledge Gaps
- **81 isolated node(s):** `name`, `private`, `esbuild`, `build`, `build:css:compile` (+76 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **36 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `Action Cable Config` and `Database Config`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `User` connect `User Model & Authorization` to `Devise Auth & UserDashboard`?**
  _High betweenness centrality (0.039) - this node is a cross-community bridge._
- **Why does `users table schema` connect `Devise Auth & UserDashboard` to `User Model & Authorization`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `ApplicationPolicy#admin?` (e.g. with `User` and `Admin::ApplicationController#authenticate_admin`) actually correct?**
  _`ApplicationPolicy#admin?` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 7 inferred relationships involving `User` (e.g. with `Scope` and `Admin::ApplicationController#authenticate_admin`) actually correct?**
  _`User` has 7 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `Admin::UsersController#download_signature` (e.g. with `Download Signature Route` and `Download Validator Signature Route`) actually correct?**
  _`Admin::UsersController#download_signature` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 8 inferred relationships involving `users table schema` (e.g. with `User` and `User#email_required?`) actually correct?**
  _`users table schema` has 8 INFERRED edges - model-reasoned connections that need verification._