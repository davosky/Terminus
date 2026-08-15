# Admin & Base Controllers

> 8 nodes · cohesion 0.25

## Key Concepts

- **application_controller.rb** (5 connections) — `app/controllers/application_controller.rb`
- **.authenticate_admin()** (2 connections) — `app/controllers/admin/application_controller.rb`
- **UsersController** (2 connections) — `app/controllers/admin/users_controller.rb`
- **home_controller.rb** (2 connections) — `app/controllers/home_controller.rb`
- **.resource_params()** (1 connections) — `app/controllers/admin/users_controller.rb`
- **application_controller.rb** (1 connections) — `app/controllers/admin/application_controller.rb`
- **.user_not_authorized()** (1 connections) — `app/controllers/application_controller.rb`
- **.index()** (1 connections) — `app/controllers/home_controller.rb`

## Relationships

- [[Pundit Authorization Policies]] (1 shared connections)

## Source Files

- `app/controllers/admin/application_controller.rb`
- `app/controllers/admin/users_controller.rb`
- `app/controllers/application_controller.rb`
- `app/controllers/home_controller.rb`

## Audit Trail

- EXTRACTED: 14 (93%)
- INFERRED: 1 (7%)
- AMBIGUOUS: 0 (0%)

---

*Part of the graphify knowledge wiki. See [[index]] to navigate.*