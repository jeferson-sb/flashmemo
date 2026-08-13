# CLAUDE.md

## Commands

### Setup
```sh
bin/setup              # bundle install, db:prepare, clear logs/tmp
bin/bundle install     # gems only
rails db:create
rails db:migrate
rails db:seed
```

### Docker (Postgres + Neo4j + API)
```sh
cp .env.example .env   # fill in POSTGRES_*, NEO4J_* before first run
docker compose up --build
docker compose run api rails db:create
docker compose run api rails db:schema:load
docker compose run api rails db:seed
docker exec -it flashmemo_api /bin/bash   # shell into the running container
```
Neo4j browser: http://localhost:7474. Rails connects to Neo4j via `NEO4J_URL`, configured separately from `config/database.yml` (see Architecture below).

### Run
```sh
bin/rails s             # or bin/dev, same thing
```

### Tests
```sh
rspec .                          # full suite
rspec spec/models/exam_spec.rb   # single file
rspec spec/models/exam_spec.rb:42   # single example by line number
```
Test DB uses `ActiveRecord::Migration.maintain_test_schema!` — pending migrations are applied automatically when specs run. `spec/support/**/*.rb` is autoloaded by `rails_helper.rb`; add new shared examples/matchers there rather than requiring them manually per spec.

### Lint / static analysis
```sh
rubocop -a       # autocorrect; project uses rubocop-rails-omakase as its base style
brakeman         # security scan (dev-only gem)
```

### Mailers
Preview at http://localhost:3000/rails/mailers (mailer previews live in `spec/mailers/previews`).

## Tech stack

- **Rails 8** (JSON-only API)
- **Ruby 3.3.4**
- **Postgres** (`pg`)
- **Neo4j** (`activegraph`, `neo4j-ruby-driver`) is a second, independent datastore used only for the mind-map graph
- **jbuilder** renders JSON views
- **ActiveStorage** for question images; **ActionMailer** for reset-password and review-reminder emails.
- **Solid Queue** for background jobs, scheduled via **whenever**-style recurring tasks defined in `config/recurring.yml`.
- **RSpec** + **FactoryBot** + **Faker** + **Shoulda Matchers** for testing.
- **rubocop-rails-omakase** is the base style (see Code style below); **Brakeman** for security scanning.

## Architecture

- **Business logic** belongs in `app/use_cases/` (one namespace per concept, one class per action, a single `perform` entry point), not in controllers or models. Pure calculation logic that doesn't touch the DB goes in `app/domain/` instead, and is called from a use case. Controllers stay thin: parse params, call a use case, render the result.
- **Two datastores**: Postgres (via ActiveRecord) is the primary store for everything user-facing. Neo4j (via `activegraph`) is used separately, only for the mind-map graph structure — it's configured via `NEO4J_URL`, independent of `config/database.yml`, and has no `schema.rb` entry.
- **Auth** is Rails' built-in HTTP Token scheme backed by a `sessions` table — not JWT, despite the `jwt` gem being in the Gemfile. Each controller opts specific actions into being public via `allow_unauthenticated_access`; everything else requires a token by default.
- **i18n**: user-facing strings (success/error messages, model names) go through `I18n.t`, with `en` and `pt-BR` locale files kept in sync.
- **Jobs**: background/scheduled work lives in `app/jobs/`. Recurring jobs are registered in `config/recurring.yml` (read by Solid Queue), not the `whenever` gem's `schedule.rb`.

## Code style

- `# frozen_string_literal: true` at the top of every Ruby file (omitted only in the one pre-existing exception, `authentication.rb` — don't propagate that; include it in new files).
- Single-quoted strings by default (`Style/StringLiterals: single_quotes`, overriding the omakase default) — use double quotes only when interpolating.
- No spaces inside array literal brackets (`[a, b]`, not `[ a, b ]`).
- Otherwise defer to `rubocop-rails-omakase`'s house style; run `rubocop -a` before considering a change done.
- Use-case classes: one namespace per domain concept, one class per verb, a single `perform` entry point — don't add multiple public methods to a use case class; extract a second use case instead.
- Prefer `I18n.t` over hardcoded strings for anything a client will see (see i18n section above).
