# Wheelhouse

Wheelhouse is a system for a neighbourhood bicycle repair shop.

The idea is to help the shop keep track of the bikes that come in for repairs, the customers who bring them, the work that needs to be done, prices, repair status and previous repairs.

The internal part of the system is used by the counter staff, mechanics and the shop owner. There is also a public price list for visitors, but repair and customer information stays private.

## Documents

- [User stories](docs/user-stories.md)
- [Domain model](docs/domain-model.md)
- [Decisions](docs/decisions.md)
- [Wireframes](docs/wireframes.md)
- [API](docs/api.md)

## The API

Wheelhouse also answers a small JSON API under `/api/v1`, read by:

- the price list section of my [personal page](https://cvbustamante.github.io/webtech-lab-01/) (public, no token);
- a script reading repairs or registering a service (needs a token).

The personal page expects the API at `http://localhost:3000`, so run the Rails server on port 3000 (the default for `bin/dev`/`bin/rails server`) for the published page to find it while you test locally.

### Serving the personal page locally

`config/initializers/cors.rb` only lets the published page and `http://localhost:5500` read the API, so serve a local copy of the personal page on port 5500. From the `webtech-lab-01` folder:

```bash
python -m http.server 5500
```

then open `http://localhost:5500` while `bin/dev` is running. Any other port gets blocked by CORS in the browser.

### Setting the token

The token lives in the encrypted credentials, not in the code:

```bash
EDITOR="code --wait" bin/rails credentials:edit
```

add (or check for) a line like:

```yaml
api_token: some-long-random-string
```

`config/master.key` is required to read/write the credentials and is not committed — ask for it. Without it, delete `config/credentials.yml.enc` and run `bin/rails credentials:edit`: Rails creates a fresh key and file, and you add your own `api_token` there.

### Trying it from the terminal

```bash
# price list, no token needed
curl http://localhost:3000/api/v1/services

# repairs, needs the token from the credentials above
curl http://localhost:3000/api/v1/repairs \
  -H "Authorization: Bearer <api_token>"
```

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

`config/database.yml` connects to `127.0.0.1` on port `5433`. If your PostgreSQL listens somewhere else (the default is 5432), set `DATABASE_URL` instead, which overrides the host and port:

```bash
export DATABASE_URL=postgres://postgres:your_postgres_password@127.0.0.1:5432/webtech_wheelhouse1_development
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
