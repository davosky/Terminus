# Secure Headers & CSP Hardening

> 8 nodes · cohesion 0.29

## Key Concepts

- **Secure Headers Initializer** (4 connections) — `config/initializers/secure_headers.rb`
- **Security Audit Performed and Documented (secure_headers/CSP added as a result)** (2 connections) — `CLAUDE.md`
- **force_ssl / ssl_options Configuration** (2 connections) — `config/environments/production.rb`
- **Rationale: Rails HSTS emission disabled because secure_headers now owns the HSTS header** (2 connections) — `config/environments/production.rb`
- **Content-Security-Policy Configuration** (2 connections) — `config/initializers/secure_headers.rb`
- **HSTS Header Configuration (production-only)** (2 connections) — `config/initializers/secure_headers.rb`
- **Secure Cookie Flags Configuration** (1 connections) — `config/initializers/secure_headers.rb`
- **Rationale: CSP style-src allows unsafe-inline for Bootstrap data-URI SVGs and Rails default error pages** (1 connections) — `config/initializers/secure_headers.rb`

## Relationships

- No strong cross-community connections detected

## Source Files

- `CLAUDE.md`
- `config/environments/production.rb`
- `config/initializers/secure_headers.rb`

## Audit Trail

- EXTRACTED: 14 (88%)
- INFERRED: 2 (12%)
- AMBIGUOUS: 0 (0%)

---

*Part of the graphify knowledge wiki. See [[index]] to navigate.*