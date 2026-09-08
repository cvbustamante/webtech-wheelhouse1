# Domain Model

## Diagram

DBML (dbdiagram.io format), updated to match `db/schema.rb` exactly after Lab 5. There are no real foreign keys yet (those arrive in Lab 7), but the relationships are still drawn here so the diagram keeps making sense.

```dbml
Table customers {
  id bigint [pk]
  name varchar [not null]
  phone varchar [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table bike_models {
  id bigint [pk]
  name varchar [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table bikes {
  id bigint [pk]
  bike_model_id bigint [not null]
  serial_number varchar [not null, unique]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table jobs {
  id bigint [pk]
  name varchar [not null, unique]
  price decimal(8,2) [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table staff_members {
  id bigint [pk]
  name varchar [not null]
  role varchar [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table repairs {
  id bigint [pk]
  bike_id bigint [not null]
  customer_id bigint [not null]
  mechanic_id bigint [null]
  status varchar [not null, default: "dropped_off"]
  promised_on date [not null]
  picked_up_at datetime [null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table repair_jobs {
  id bigint [pk]
  repair_id bigint [not null]
  job_id bigint [not null]
  price_charged decimal(8,2) [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Ref: bikes.bike_model_id > bike_models.id
Ref: repairs.bike_id > bikes.id
Ref: repairs.customer_id > customers.id
Ref: repairs.mechanic_id > staff_members.id
Ref: repair_jobs.repair_id > repairs.id
Ref: repair_jobs.job_id > jobs.id
```

## Relationships

A `bike_model` can describe many physical bikes, while each bike has one model.

A bike can have many repairs over its life, while each repair belongs to one specific physical bike. This keeps the repair history attached to the bike even if the bike changes owners.

A customer can bring in many repairs over time, while each repair records the customer who brought the bike in for that visit.

A staff member with role `mechanic` can be assigned to many repairs, while each repair has at most one mechanic assigned (or none yet, if it is still `dropped_off`).

A repair can contain several jobs, and the same job can be used in many different repairs. `repair_jobs` connects them.

`repair_jobs` is not only a join table because it also stores `price_charged`, which is the price actually used for that job on that repair.

Arrival photos and the diagnosis text are still out of the schema for now (see "Changes since Lab 3").

## Changes since Lab 3

These are the changes compared to my Lab 3 diagram, each with its reason:

- **`promised_date` renamed to `promised_on`**: Rails convention, the `_on` suffix is for day-only dates and `_at` is for point-in-time instants. `promised_date` did not follow that convention.

- **`jobs.price` and `repair_jobs.price_charged` changed from integer to decimal (precision: 8, scale: 2)**: in Lab 3 I had them as integer. Lab 5 forbids using integer or float for money, since float loses precision and a plain integer does not make it clear whether it means whole currency units or cents. A decimal with a fixed precision/scale avoids both problems.

- **`diagnosis` (text) column removed from `repairs` for now**: it was in my Lab 3 diagram, but it arrives in Lab 9 along with the photos table.

- **`photos` table not created for now**: same reason, arrives in Lab 9.

- **`staff_members` table added, with `repairs.mechanic_id` nullable**: this one is not in my Lab 3 diagram. None of my user stories asked to store staff data, mechanic and counter staff are just roles of whoever uses the system, not something I thought the database needed to keep. But this lab asks the seed to include the three mechanics and the counter person, so I needed somewhere to put them, and `mechanic_id` on `repairs` gave me a real nullable foreign key to work with (a repair that just came in does not have a mechanic assigned yet).

## Repair lifecycle

For this model I assumed that every repair needs customer approval before work starts. The description is not completely clear about quick repairs, so this assumption is also documented in `decisions.md`.

The repair states are:

```text
dropped_off
|
v
diagnosed
|
v
waiting_for_approval
/ \
v v
declined in_progress
| |
| v
| ready
| |
v v
picked_up picked_up
```

### Allowed transitions

- `dropped_off -> diagnosed`: the bike has been inspected and the diagnosis has been recorded.
- `diagnosed -> waiting_for_approval`: the diagnosis and proposed jobs are ready and the shop is waiting for the customer's answer.
- `waiting_for_approval -> in_progress`: the customer approved the quote and work can begin.
- `waiting_for_approval -> declined`: the customer declined the quote.
- `in_progress -> ready`: the repair work has been completed.
- `ready -> picked_up`: the repaired bike has been collected.
- `declined -> picked_up`: the customer collected the bike without the proposed repair being done.

### Transitions that are not allowed

- `waiting_for_approval -> ready`: a repair cannot be completed before work begins.
- `declined -> in_progress`: work cannot start after the customer declined the quote.
- `in_progress -> picked_up`: the repair must first be marked as ready.
- `picked_up -> anything`: once the bike has been picked up, that repair is closed.

### When a repair has repair_jobs

A repair in `dropped_off` or `diagnosed` has no rows in `repair_jobs`, since no quote exists yet at that point. From `waiting_for_approval` onward the repair has between 1 and 4 rows in `repair_jobs`.

## Entity traceability

| Entity | Story that requires it |
|---|---|
| `customers` | Story 1 — the shop needs the customer's name and phone number |
| `bike_models` | Story 2 — the shop records what kind of bike it is |
| `bikes` | Story 2 — each physical bike must be distinguished by its serial number |
| `repairs` | Story 10 — the shop needs to know the current status of each repair |
| `jobs` | Story 5 — mechanics select the jobs needed from the price list |
| `repair_jobs` | Stories 5, 8 and 14 — a repair contains jobs and each one has a price for that repair |
| `staff_members` | No story from Lab 3, added later so mechanics and counter staff could be seeded |

(`photos` is not in this table anymore since that table does not exist yet.)

## Model decisions

### The thing and the copy of the thing

A bike model such as "Trek Marlin" is not the same as the physical bike that enters the shop. `bike_models` stores what kind of bike it is, while `bikes` stores each individual physical bike with its own serial number.

Two bikes can therefore both be Trek Marlins but still have different serial numbers and different repair histories.

If I used only a bike model with a `quantity` column, the shop could know that there are two Trek Marlins, but it could not tell which physical bike is currently being repaired or which repair history belongs to each one. That is the problem the owner describes when two similar bikes were mixed up.

### Derived or stored?

The model does not have an `is_late` column. Whether a repair is late can be worked out by comparing `promised_on` with today's date and checking that the repair is not already `ready` or `picked_up`. Storing another column for the same information could make the two values disagree.

On the other hand, `repair_jobs.price_charged` is stored even though it looks like it could come from `jobs.price`. The shop sometimes charges less than the listed price, and the price list also changes over time. If `price_charged` was not stored, an old repair could appear to have a different price after the price list changes.
