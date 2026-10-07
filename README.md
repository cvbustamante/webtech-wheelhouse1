# Wheelhouse

Wheelhouse is a system for a neighbourhood bicycle repair shop.

The idea is to help the shop keep track of the bikes that come in for repairs, the customers who bring them, the work that needs to be done, prices, repair status and previous repairs.

The internal part of the system is used by the counter staff, mechanics and the shop owner. There is also a public price list for visitors, but repair and customer information stays private.

## Documents

- [User stories](docs/user-stories.md)
- [Domain model](docs/domain-model.md)
- [Decisions](docs/decisions.md)
- [Wireframes](docs/wireframes.md)

## Requirements

- Ruby 4.0.4
- Rails 8.0
- Node 26.1.0
- PostgreSQL, with the `postgres` role available (see `config/database.yml`)
- libvips, for processing the intake photo thumbnails (Active Storage variants)

The app expects that role's password in the `POSTGRES_PASSWORD` environment variable:

```bash
export POSTGRES_PASSWORD=your_postgres_password
```

On Ubuntu/WSL, install libvips with:

```bash
sudo apt-get update
sudo apt-get install libvips
```

## Setup

```bash
git clone <repo-url>
cd webtech-wheelhouse1
bundle install
npm install
bin/rails db:prepare
bin/dev
```

`bin/rails db:prepare` creates the database, loads the schema and runs the seed file in one step. No other database command is needed on a fresh clone.

`bin/dev` starts the server and the CSS watcher. The app runs at `http://localhost:3000`.

If `db:prepare` fails on the very first run with a connection error, run `bin/rails db:create` and then `bin/rails db:prepare` again.

`db/seeds.rb` wipes the tables before inserting, so running `bin/rails db:seed` again does not duplicate rows.
