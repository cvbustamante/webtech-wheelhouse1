# Wheelhouse

Wheelhouse is a system for a neighbourhood bicycle repair shop.

The idea is to help the shop keep track of the bikes that come in for repairs, the customers who bring them, the work that needs to be done, prices, repair status and previous repairs.

The internal part of the system is used by the counter staff, mechanics and the shop owner. There is also a public price list for visitors, but repair and customer information stays private.

This repository contains the specification for Wheelhouse that will be used in the next labs.

## Documents

- [User stories](docs/user-stories.md)
- [Domain model](docs/domain-model.md)
- [Decisions](docs/decisions.md)
- [Wireframes](docs/wireframes.md)
## Requirements

- Ruby 4.0.4
- Rails 8.0
- Node 26.1.0
- PostgreSQL

## Setup

```bash
bundle install
npm install
bin/rails db:create