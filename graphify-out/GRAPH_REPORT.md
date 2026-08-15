# Graph Report - .  (2026-08-15)

## Corpus Check
- 1 files · ~18,486 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 178 nodes · 136 edges · 71 communities (37 shown, 34 thin omitted)
- Extraction: 67% EXTRACTED · 32% INFERRED · 1% AMBIGUOUS · INFERRED: 44 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Username Auth Flow (User + Devise + Admin Dashboard)|Username Auth Flow (User + Devise + Admin Dashboard)]]
- [[_COMMUNITY_JSCSS Dependencies (Bootstrap, Stimulus)|JS/CSS Dependencies (Bootstrap, Stimulus)]]
- [[_COMMUNITY_Dev Tooling & CI Scripts|Dev Tooling & CI Scripts]]
- [[_COMMUNITY_Pundit Authorization Policies|Pundit Authorization Policies]]
- [[_COMMUNITY_Frontend Build Scripts|Frontend Build Scripts]]
- [[_COMMUNITY_CLAUDE.md Terminus App Spec|CLAUDE.md Terminus App Spec]]
- [[_COMMUNITY_Admin & Base Controllers|Admin & Base Controllers]]
- [[_COMMUNITY_Rails App Boot & Devise Setup|Rails App Boot & Devise Setup]]
- [[_COMMUNITY_Rails Environment Configs|Rails Environment Configs]]
- [[_COMMUNITY_CSRF Security Practices|CSRF Security Practices]]
- [[_COMMUNITY_CableDBPuma Runtime Config|Cable/DB/Puma Runtime Config]]
- [[_COMMUNITY_Secrets & Env Vars Guidance|Secrets & Env Vars Guidance]]
- [[_COMMUNITY_SQL Injection & DB Conventions|SQL Injection & DB Conventions]]
- [[_COMMUNITY_TestDev Database Isolation Rule|Test/Dev Database Isolation Rule]]
- [[_COMMUNITY_Bundler Audit & CI Pipeline|Bundler Audit & CI Pipeline]]
- [[_COMMUNITY_FlashController Manifest Registration|FlashController Manifest Registration]]
- [[_COMMUNITY_Login Page Logo & Layout|Login Page Logo & Layout]]
- [[_COMMUNITY_Italian Locale devise-i18n Fix|Italian Locale devise-i18n Fix]]
- [[_COMMUNITY_UserDashboarddisplay_resource|UserDashboard#display_resource]]
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

## God Nodes (most connected - your core abstractions)
1. `ApplicationPolicy#admin?` - 13 edges
2. `User` - 12 edges
3. `Costruzione dell'Applicazione Terminus` - 7 edges
4. `scripts` - 6 edges
5. `GitHub Actions CI Workflow` - 6 edges
6. `DeviseCreateUsers` - 5 edges
7. `Scope` - 4 edges
8. `users table schema` - 4 edges
9. `:user FactoryBot factory` - 4 edges
10. `Devise Initializer` - 4 edges

## Surprising Connections (you probably didn't know these)
- `Login system spec` --references--> `User`  [INFERRED]
  spec/system/login_spec.rb → app/models/user.rb
- `Admin::ApplicationController#authenticate_admin` --semantically_similar_to--> `ApplicationPolicy#admin?`  [INFERRED] [semantically similar]
  app/controllers/admin/application_controller.rb → app/policies/application_policy.rb
- `User` --shares_data_with--> `users table schema`  [INFERRED]
  app/models/user.rb → db/schema.rb
- `User` --shares_data_with--> `DeviseCreateUsers`  [INFERRED]
  app/models/user.rb → db/migrate/20260815090539_devise_create_users.rb
- `:user FactoryBot factory` --shares_data_with--> `User`  [INFERRED]
  spec/factories/users.rb → app/models/user.rb

## Communities (71 total, 34 thin omitted)

### Community 0 - "Username Auth Flow (User + Devise + Admin Dashboard)"
Cohesion: 0.14
Nodes (11): Admin::ApplicationController#authenticate_admin, Admin::UsersController#resource_params, users table schema, db/seeds.rb admin user seed, :user FactoryBot factory, DeviseCreateUsers, User#email_required?, User model spec (+3 more)

### Community 1 - "JS/CSS Dependencies (Bootstrap, Stimulus)"
Cohesion: 0.13
Nodes (14): Stack Tecnico, Terminus Interfaccia Grafica Spec, README, browserslist, devDependencies, esbuild, name, private (+6 more)

### Community 2 - "Dev Tooling & CI Scripts"
Cohesion: 0.20
Nodes (14): bin/brakeman Runner Script, bin/bundler-audit Runner Script, bin/ci Runner Script, bin/dev Server Script, bin/docker-entrypoint Script, bin/rails CLI Script, bin/rubocop Runner Script, bin/setup Script (+6 more)

### Community 3 - "Pundit Authorization Policies"
Cohesion: 0.27
Nodes (3): ApplicationController#user_not_authorized, ApplicationPolicy#admin?, Scope

### Community 4 - "Frontend Build Scripts"
Cohesion: 0.20
Nodes (10): dependencies, autoprefixer, bootstrap, bootswatch, @hotwired/stimulus, nodemon, @popperjs/core, postcss (+2 more)

### Community 5 - "CLAUDE.md Terminus App Spec"
Cohesion: 0.33
Nodes (9): Autenticazione e Autorizzazione Robuste, Gem Principali, Graphify Knowledge Graph Setup, Terminus Amministrazione Spec, Costruzione dell'Applicazione Terminus, Terminus Autenticazione Spec, Terminus Autorizzazione Spec, Terminus Database Spec (+1 more)

### Community 7 - "Rails App Boot & Devise Setup"
Cohesion: 0.25
Nodes (8): Terminus::Application, Boot Configuration, Environment Loader, Application Routes, Devise Initializer, Filter Parameter Logging Initializer, Devise English Locale, English Locale

### Community 9 - "Rails Environment Configs"
Cohesion: 0.50
Nodes (4): Active Storage Config, Development Environment Config, Production Environment Config, Test Environment Config

### Community 10 - "CSRF Security Practices"
Cohesion: 0.67
Nodes (3): Protezione CSRF, Best Practice di Sicurezza per Ruby on Rails, Sicurezza (Project Conventions)

### Community 11 - "Cable/DB/Puma Runtime Config"
Cohesion: 0.67
Nodes (3): Action Cable Config, Database Config, Puma Server Config

## Ambiguous Edges - Review These
- `Action Cable Config` → `Database Config`  [AMBIGUOUS]
  config/cable.yml · relation: conceptually_related_to

## Knowledge Gaps
- **69 isolated node(s):** `name`, `private`, `esbuild`, `build`, `build:css:compile` (+64 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **34 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `Action Cable Config` and `Database Config`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `User` connect `Username Auth Flow (User + Devise + Admin Dashboard)` to `Pundit Authorization Policies`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Why does `ApplicationPolicy#admin?` connect `Pundit Authorization Policies` to `Username Auth Flow (User + Devise + Admin Dashboard)`?**
  _High betweenness centrality (0.025) - this node is a cross-community bridge._
- **Why does `dependencies` connect `Frontend Build Scripts` to `JS/CSS Dependencies (Bootstrap, Stimulus)`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `ApplicationPolicy#admin?` (e.g. with `User` and `Admin::ApplicationController#authenticate_admin`) actually correct?**
  _`ApplicationPolicy#admin?` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Are the 7 inferred relationships involving `User` (e.g. with `Scope` and `Admin::ApplicationController#authenticate_admin`) actually correct?**
  _`User` has 7 INFERRED edges - model-reasoned connections that need verification._
- **What connects `name`, `private`, `esbuild` to the rest of the system?**
  _77 weakly-connected nodes found - possible documentation gaps or missing edges._