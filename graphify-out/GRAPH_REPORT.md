# Graph Report - .  (2026-08-15)

## Corpus Check
- 17 files · ~19,894 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 241 nodes · 226 edges · 79 communities (43 shown, 36 thin omitted)
- Extraction: 67% EXTRACTED · 33% INFERRED · 0% AMBIGUOUS · INFERRED: 74 edges (avg confidence: 0.86)
- Token cost: 107,228 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Pundit Authorization & User Model|Pundit Authorization & User Model]]
- [[_COMMUNITY_CarrierWave Signature Uploaders|CarrierWave Signature Uploaders]]
- [[_COMMUNITY_User Schema & Migrations|User Schema & Migrations]]
- [[_COMMUNITY_Frontend Deps & Project Docs|Frontend Deps & Project Docs]]
- [[_COMMUNITY_Dev Tooling & CI Scripts|Dev Tooling & CI Scripts]]
- [[_COMMUNITY_Admin Signature Download Routes|Admin Signature Download Routes]]
- [[_COMMUNITY_CLAUDE.md Terminus App Spec|CLAUDE.md Terminus App Spec]]
- [[_COMMUNITY_JS Frontend Dependencies|JS Frontend Dependencies]]
- [[_COMMUNITY_Rails App Boot & Devise Setup|Rails App Boot & Devise Setup]]
- [[_COMMUNITY_Secure Headers & CSP Hardening|Secure Headers & CSP Hardening]]
- [[_COMMUNITY_Security Guide & DB Credential Hygiene|Security Guide & DB Credential Hygiene]]
- [[_COMMUNITY_Rails Environment Configs|Rails Environment Configs]]
- [[_COMMUNITY_CableDBPuma Runtime Config|Cable/DB/Puma Runtime Config]]
- [[_COMMUNITY_Admin Users Routes & Controller|Admin Users Routes & Controller]]
- [[_COMMUNITY_Validator Fields Migration|Validator Fields Migration]]
- [[_COMMUNITY_User Signature Migration|User Signature Migration]]
- [[_COMMUNITY_Confirmator Fields Migration|Confirmator Fields Migration]]
- [[_COMMUNITY_SQL Injection & DB Conventions|SQL Injection & DB Conventions]]
- [[_COMMUNITY_Secrets & Env Vars Guidance|Secrets & Env Vars Guidance]]
- [[_COMMUNITY_Bundler Audit & CI Pipeline|Bundler Audit & CI Pipeline]]
- [[_COMMUNITY_FlashController Manifest Registration|FlashController Manifest Registration]]
- [[_COMMUNITY_Italian Locale devise-i18n Fix|Italian Locale devise-i18n Fix]]
- [[_COMMUNITY_Login Page Logo & Layout|Login Page Logo & Layout]]
- [[_COMMUNITY_ApplicationHelper Module|ApplicationHelper Module]]
- [[_COMMUNITY_JS Application Entry Point|JS Application Entry Point]]
- [[_COMMUNITY_Useremail_changed|User#email_changed?]]
- [[_COMMUNITY_PWA Service Worker Placeholder|PWA Service Worker Placeholder]]
- [[_COMMUNITY_Spec Helper RSpec Config|Spec Helper RSpec Config]]
- [[_COMMUNITY_Assets Initializer|Assets Initializer]]
- [[_COMMUNITY_Content Security Policy Initializer|Content Security Policy Initializer]]
- [[_COMMUNITY_Inflections Initializer|Inflections Initializer]]
- [[_COMMUNITY_Rake CLI Script|Rake CLI Script]]
- [[_COMMUNITY_Thruster Runner Script|Thruster Runner Script]]
- [[_COMMUNITY_400 Bad Request Page|400 Bad Request Page]]
- [[_COMMUNITY_404 Not Found Page|404 Not Found Page]]
- [[_COMMUNITY_406 Unsupported Browser Page|406 Unsupported Browser Page]]
- [[_COMMUNITY_422 Unprocessable Entity Page|422 Unprocessable Entity Page]]
- [[_COMMUNITY_500 Internal Server Error Page|500 Internal Server Error Page]]
- [[_COMMUNITY_Project Structure Docs|Project Structure Docs]]
- [[_COMMUNITY_Performance Conventions Docs|Performance Conventions Docs]]
- [[_COMMUNITY_Claude Code Workflow Docs|Claude Code Workflow Docs]]
- [[_COMMUNITY_Anti-Patterns to Avoid Docs|Anti-Patterns to Avoid Docs]]
- [[_COMMUNITY_XSS Mitigation Guide|XSS Mitigation Guide]]
- [[_COMMUNITY_Session & Cookie Security Guide|Session & Cookie Security Guide]]
- [[_COMMUNITY_Secure File Upload Guide|Secure File Upload Guide]]
- [[_COMMUNITY_Default Rails Favicon Asset|Default Rails Favicon Asset]]
- [[_COMMUNITY_Color Palette Swatches|Color Palette Swatches]]
- [[_COMMUNITY_Navbar Logo Asset|Navbar Logo Asset]]
- [[_COMMUNITY_CarrierWave Global Config|CarrierWave Global Config]]
- [[_COMMUNITY_Signature Test Fixture|Signature Test Fixture]]

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
- **User Signature Upload and Download Flow** — models_user_mount_user_signature, uploaders_user_signature_uploader_class, admin_users_controller_download_signature, config_routes_download_signature, fields_carrierwave_field_class [INFERRED 0.85]
- **Validator Signature Field-to-Test Workflow Pattern** — migrate_add_validator_fields_to_users_class, models_user_mount_validator_signature, uploaders_validator_signature_uploader_class, admin_users_controller_download_validator_signature, admin_user_signature_upload_spec_validator_signature_test [INFERRED 0.85]
- **CarrierWave Global Upload Security Policy** — initializers_carrierwave_extension_allowlist, initializers_carrierwave_content_type_allowlist, uploaders_user_signature_uploader_class, uploaders_validator_signature_uploader_class, uploaders_confirmator_signature_uploader_class [INFERRED 0.85]

## Communities (79 total, 36 thin omitted)

### Community 0 - "Pundit Authorization & User Model"
Cohesion: 0.14
Nodes (10): Admin::ApplicationController#authenticate_admin, ApplicationController#user_not_authorized, db/seeds.rb admin user seed, :user FactoryBot factory, User model spec, User, ApplicationPolicy#admin?, Scope (+2 more)

### Community 1 - "CarrierWave Signature Uploaders"
Cohesion: 0.20
Nodes (12): Admin::UsersController#download_signature, Admin::UsersController#resource_params, Admin::UsersController#send_uploaded_file, content_type_allowlist(), extension_allowlist(), Italian User Attribute Translations, User mount_uploader confirmator_signature, User mount_uploader user_signature (+4 more)

### Community 2 - "User Schema & Migrations"
Cohesion: 0.14
Nodes (11): Devise Routes for Users, UserDashboard, UserDashboard#display_resource, users table schema, DeviseCreateUsers, AddConfirmatorFieldsToUsers Migration, AddInstituteAndOfficeToUsers Migration, AddUserSignatureToUsers Migration (+3 more)

### Community 3 - "Frontend Deps & Project Docs"
Cohesion: 0.12
Nodes (15): Stack Tecnico, LICENCE (Bilingual MIT License), README, README English Translation Section, browserslist, devDependencies, esbuild, name (+7 more)

### Community 4 - "Dev Tooling & CI Scripts"
Cohesion: 0.20
Nodes (14): bin/brakeman Runner Script, bin/bundler-audit Runner Script, bin/ci Runner Script, bin/dev Server Script, bin/docker-entrypoint Script, bin/rails CLI Script, bin/rubocop Runner Script, bin/setup Script (+6 more)

### Community 5 - "Admin Signature Download Routes"
Cohesion: 0.21
Nodes (8): UsersController, Download Confirmator Signature Route, Download Signature Route, Download Validator Signature Route, UserDashboard::ATTRIBUTE_TYPES, CarrierwaveField#filename, CarrierwaveField#uploader, CarrierwaveField#url

### Community 6 - "CLAUDE.md Terminus App Spec"
Cohesion: 0.29
Nodes (10): Autenticazione e Autorizzazione Robuste, Gem Principali, Graphify Knowledge Graph Setup, Terminus Amministrazione Spec, Costruzione dell'Applicazione Terminus, Terminus Autenticazione Spec, Terminus Autorizzazione Spec, Terminus Database Spec (+2 more)

### Community 7 - "JS Frontend Dependencies"
Cohesion: 0.20
Nodes (10): dependencies, autoprefixer, bootstrap, bootswatch, @hotwired/stimulus, nodemon, @popperjs/core, postcss (+2 more)

### Community 8 - "Rails App Boot & Devise Setup"
Cohesion: 0.25
Nodes (8): Terminus::Application, Boot Configuration, Environment Loader, Application Routes, Devise Initializer, Filter Parameter Logging Initializer, Devise English Locale, English Locale

### Community 9 - "Secure Headers & CSP Hardening"
Cohesion: 0.29
Nodes (8): Security Audit Performed and Documented (secure_headers/CSP added as a result), force_ssl / ssl_options Configuration, Rationale: Rails HSTS emission disabled because secure_headers now owns the HSTS header, Secure Headers Initializer, Secure Cookie Flags Configuration, Content-Security-Policy Configuration, HSTS Header Configuration (production-only), Rationale: CSP style-src allows unsafe-inline for Bootstrap data-URI SVGs and Rails default error pages

### Community 10 - "Security Guide & DB Credential Hygiene"
Cohesion: 0.33
Nodes (6): Protezione CSRF, Dev DB Credentials Redacted from NOTA BENE, Best Practice di Sicurezza per Ruby on Rails, Sicurezza (Project Conventions), Test/Development Database Isolation Rule, Regole per i Test

### Community 13 - "Rails Environment Configs"
Cohesion: 0.50
Nodes (4): Active Storage Config, Development Environment Config, Production Environment Config, Test Environment Config

### Community 14 - "Cable/DB/Puma Runtime Config"
Cohesion: 0.67
Nodes (3): Action Cable Config, Database Config, Puma Server Config

### Community 15 - "Admin Users Routes & Controller"
Cohesion: 0.67
Nodes (3): Admin::UsersController, Admin Root Route, Admin Namespace Users Resources

## Ambiguous Edges - Review These
- `Action Cable Config` → `Database Config`  [AMBIGUOUS]
  config/cable.yml · relation: conceptually_related_to

## Knowledge Gaps
- **76 isolated node(s):** `name`, `private`, `esbuild`, `build`, `build:css:compile` (+71 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **36 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `Action Cable Config` and `Database Config`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `User` connect `Pundit Authorization & User Model` to `User Schema & Migrations`?**
  _High betweenness centrality (0.041) - this node is a cross-community bridge._
- **Why does `users table schema` connect `User Schema & Migrations` to `Pundit Authorization & User Model`?**
  _High betweenness centrality (0.037) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `ApplicationPolicy#admin?` (e.g. with `User` and `Admin::ApplicationController#authenticate_admin`) actually correct?**
  _`ApplicationPolicy#admin?` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 7 inferred relationships involving `User` (e.g. with `Scope` and `Admin::ApplicationController#authenticate_admin`) actually correct?**
  _`User` has 7 INFERRED edges - model-reasoned connections that need verification._
- **Are the 3 inferred relationships involving `Admin::UsersController#download_signature` (e.g. with `Download Signature Route` and `Download Validator Signature Route`) actually correct?**
  _`Admin::UsersController#download_signature` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 8 inferred relationships involving `users table schema` (e.g. with `User` and `User#email_required?`) actually correct?**
  _`users table schema` has 8 INFERRED edges - model-reasoned connections that need verification._