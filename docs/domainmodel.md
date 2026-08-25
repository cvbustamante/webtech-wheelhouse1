# Domain Model

## Diagram


## Relationships

A `bike_model` can describe many physical bikes, while each bike has one model.

A bike can have many repairs over its life, while each repair belongs to one specific physical bike. This keeps the repair history attached to the bike even if the bike changes owners.

A customer can bring in many repairs over time, while each repair records the customer who brought the bike in for that visit.

A repair can contain several jobs, and the same job can be used in many different repairs. `repair_jobs` connects them.

`repair_jobs` is not only a join table because it also stores `price_charged`, which is the price actually used for that job on that repair.

A repair can have several arrival photos, while each photo belongs to one repair.

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

## Entity traceability

| Entity | Story that requires it |
|---|---|
| `customers` | Story 1 — the shop needs the customer's name and phone number |
| `bike_models` | Story 2 — the shop records what kind of bike it is |
| `bikes` | Story 2 — each physical bike must be distinguished by its serial number |
| `repairs` | Story 10 — the shop needs to know the current status of each repair |
| `jobs` | Story 5 — mechanics select the jobs needed from the price list |
| `repair_jobs` | Stories 5, 8 and 14 — a repair contains jobs and each one has a price for that repair |
| `photos` | Story 3 — arrival photos are kept with the repair |

## Model decisions

### The thing and the copy of the thing

A bike model such as "Trek Marlin" is not the same as the physical bike that enters the shop. `bike_models` stores what kind of bike it is, while `bikes` stores each individual physical bike with its own serial number.

Two bikes can therefore both be Trek Marlins but still have different serial numbers and different repair histories.

If I used only a bike model with a `quantity` column, the shop could know that there are two Trek Marlins, but it could not tell which physical bike is currently being repaired or which repair history belongs to each one. That is the problem the owner describes when two similar bikes were mixed up.

### Derived or stored?

The model does not have an `is_late` column. Whether a repair is late can be worked out by comparing `promised_date` with today's date and checking that the repair is not already `ready` or `picked_up`. Storing another column for the same information could make the two values disagree.

On the other hand, `repair_jobs.price_charged` is stored even though it looks like it could come from `jobs.price`. The shop sometimes charges less than the listed price, and the price list also changes over time. If `price_charged` was not stored, an old repair could appear to have a different price after the price list changes.