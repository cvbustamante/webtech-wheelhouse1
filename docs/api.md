# API

Everything is under `/api/v1`. Every response is JSON, errors included.

## Routes

| Verb | Path | Token | Statuses |
|---|---|---|---|
| GET | `/api/v1/services` | no | 200 |
| GET | `/api/v1/services/:id` | no | 200, 404 |
| POST | `/api/v1/services` | yes | 201, 400, 401, 422 |
| GET | `/api/v1/repairs` | yes | 200, 400, 401 |
| GET | `/api/v1/repairs/:id` | yes | 200, 401, 404 |

The token goes in the `Authorization` header, as `Bearer <token>`. See the README for where it lives.

Any other path or verb under `/api/v1` answers 404 with the error shape below.

## Documents

### A service

```json
{
  "id": 23,
  "name": "Tune-up",
  "price": "35000.00",
  "repairs_count": 3
}
```

`repairs_count` is how many different repairs have charged this service — not a column, counted from `repair_jobs`.

Create (`POST /api/v1/services`) expects the same shape the service wraps its own attributes in:

```json
{ "service": { "name": "Seat adjustment", "price": 5000 } }
```

and answers `201` with the created service's document (same shape as above) and a `Location` header pointing at it.

### A repair

```json
{
  "id": 29,
  "state": "picked_up",
  "dropped_off_on": "2025-12-05",
  "promised_on": "2025-12-10",
  "picked_up_on": "2025-12-11",
  "bike": {
    "brand": "Bianchi",
    "model": "Camaleonte",
    "serial_number": "BC-5001"
  },
  "customer": { "name": "Pedro Salinas" },
  "lines": [
    { "service": "Tune-up", "price_charged": "30000.00" },
    { "service": "Cassette replacement", "price_charged": "20000.00" }
  ],
  "total": "50000.00",
  "overdue": false,
  "customer_answer": "in_progress"
}
```

`picked_up_on` is `null` while the bike has not been handed back.

### A collection of repairs

A plain JSON array of repair documents, not wrapped in another object, ordered by `promised_on`. `GET /api/v1/repairs?state=declined` filters it; an unknown `state` answers 400.

```json
[
  {
    "id": 31,
    "state": "declined",
    "dropped_off_on": "2026-10-27",
    "promised_on": "2026-10-27",
    "picked_up_on": null,
    "bike": {
      "brand": "Scott",
      "model": "Aspect",
      "serial_number": "SA-4001"
    },
    "customer": { "name": "Ignacio Vera" },
    "lines": [
      { "service": "Suspension service", "price_charged": "60000.00" }
    ],
    "total": "60000.00",
    "overdue": true,
    "customer_answer": "declined"
  }
]
```

### An error

Every 400, 401, 404 and 422 look the same:

```json
{ "errors": ["state must be one of: dropped_off, diagnosed, waiting_for_approval, in_progress, ready, picked_up, declined"] }
```

```json
{ "errors": ["Name can't be blank", "Price must be greater than 0"] }
```

## Decisions

**Price travels as a string**, like `"35000.00"`, always with two decimals — in the service document, in each repair line, and in the repair's `total`. `price` and `price_charged` are `decimal` columns; turning them into a JSON number risks the usual floating point rounding, and a client reading money should not have to guess whether `35000.0` means `35000.00` or something that already lost a cent. A string the client parses as a decimal avoids that.

**What the repair document leaves out, and why:**
- `bike_id`, `customer_id`, `mechanic_id`, every `repair_jobs` row's own `id` — foreign keys and internal ids are not something the accounting program reads anything from; it already gets the bike, the customer and the lines nested where it needs them.
- the mechanic — not asked for, and not accounting information.
- the customer's phone — the lab says explicitly to leave it out.
- `created_at`/`updated_at` and `picked_up_at` as raw timestamps — `dropped_off_on` and `picked_up_on` already carry the one day that matters (`created_at.to_date`, `picked_up_at.to_date`); the exact timestamp down to the millisecond is not useful for a handed-back bike.

**`bike.brand` / `bike.model`**: the schema only has one `bike_models.name` column (`"Trek Marlin"`), by design since Lab 3 — a new column was not added just for this. The document splits it on the first space (`"Trek"` / `"Marlin"`). Every bike model currently in the shop follows that two-word pattern, so this works today; a bike model whose name is a single word would show that same word as both brand and model rather than leaving one blank.

**`customer_answer`**: the schema does not keep a separate record of "what the customer said," only the current `status`. `waiting_for_approval` and anything before it has no answer yet (`null`). `declined` answers `"declined"`. Everything from `in_progress` onward answers `"in_progress"`, using the lifecycle's own state names rather than inventing `"approved"`/`"yes"`. Because there is no separate history column, a repair that was declined and later still picked up (the shop does let the customer collect a declined bike) would read by its current status, not by what was originally answered — the same trade-off as not adding a new column just for this lab.
