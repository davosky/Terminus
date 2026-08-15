# Username Auth Flow (User + Devise + Admin Dashboard)

> 18 nodes · cohesion 0.14

## Key Concepts

- **User** (12 connections) — `app/models/user.rb`
- **DeviseCreateUsers** (5 connections) — `db/migrate/20260815090539_devise_create_users.rb`
- **user_dashboard.rb** (4 connections) — `app/dashboards/user_dashboard.rb`
- **users table schema** (4 connections) — `db/schema.rb`
- **:user FactoryBot factory** (4 connections) — `spec/factories/users.rb`
- **Admin::ApplicationController#authenticate_admin** (2 connections) — `app/controllers/admin/application_controller.rb`
- **User model spec** (2 connections) — `spec/models/user_spec.rb`
- **Login system spec** (2 connections) — `spec/system/login_spec.rb`
- **Admin::UsersController#resource_params** (1 connections) — `app/controllers/admin/users_controller.rb`
- **user.rb** (1 connections) — `app/models/user.rb`
- **.display_resource()** (1 connections) — `app/dashboards/user_dashboard.rb`
- **20260815090539_devise_create_users.rb** (1 connections) — `db/migrate/20260815090539_devise_create_users.rb`
- **db/seeds.rb admin user seed** (1 connections) — `db/seeds.rb`
- **.change()** (1 connections) — `db/migrate/20260815090539_devise_create_users.rb`
- **User#email_required?** (1 connections) — `app/models/user.rb`
- **.email_changed?()** (1 connections) — `app/models/user.rb`
- **.email_required?()** (1 connections) — `app/models/user.rb`
- **rails_helper RSpec config** (1 connections) — `spec/rails_helper.rb`

## Relationships

- [[Pundit Authorization Policies]] (3 shared connections)

## Source Files

- `app/controllers/admin/application_controller.rb`
- `app/controllers/admin/users_controller.rb`
- `app/dashboards/user_dashboard.rb`
- `app/models/user.rb`
- `db/migrate/20260815090539_devise_create_users.rb`
- `db/schema.rb`
- `db/seeds.rb`
- `spec/factories/users.rb`
- `spec/models/user_spec.rb`
- `spec/rails_helper.rb`
- `spec/system/login_spec.rb`

## Audit Trail

- EXTRACTED: 24 (53%)
- INFERRED: 21 (47%)
- AMBIGUOUS: 0 (0%)

---

*Part of the graphify knowledge wiki. See [[index]] to navigate.*