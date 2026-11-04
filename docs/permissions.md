# Permissions

What each role may do, as the policies in `app/policies/` enforce it. A visitor is someone with no session. Anything a role may not do answers **403** with the "not allowed" page; a visitor is sent to sign in instead (except on the public pages of the services).

"Handed back" means the repair is in `picked_up`, the final state of the lifecycle in [domain-model.md](domain-model.md). A mechanic's "own" repairs are the ones whose mechanic is the member of the staff joined to their account; a mechanic account with no member of the staff has no own repairs.

No page lists, edits or deletes accounts.

## Services (`JobPolicy`)

| Action | Owner | Counter | Mechanic | Visitor |
|---|---|---|---|---|
| index (the price list) | Yes | Yes | Yes | Yes |
| show | Yes | Yes | Yes | Yes |
| new / create | Yes | No | No | No (sent to sign in) |
| edit / update | Yes | No | No | No (sent to sign in) |
| destroy | Yes | No | No | No (sent to sign in) |

## Staff (`StaffMemberPolicy`)

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | Yes |
| show | Yes | Yes, but the list of repairs on the page shows only the repairs that account may read | Yes, but the list of repairs on the page shows only their own |
| new / create | Yes | No | No |
| edit / update | Yes | No | No |
| destroy | Yes (refused while the member has an account) | No | No |

## Customers (`CustomerPolicy`)

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | No |
| show | Yes | Yes | No |
| new / create | Yes | Yes | No |
| edit / update | Yes | Yes | No |
| destroy | Yes | No | No |

## Bikes (`BikePolicy`)

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | No |
| show | Yes | Yes | No |
| new / create | Yes | Yes | No |
| edit / update | Yes | Yes | No |
| destroy | Yes | No | No |

## Repairs (`RepairPolicy`)

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Every repair | Every repair | Only their own (none without a member of the staff) |
| show | Every repair | Every repair | Only their own |
| new / create (taking in) | Yes | Yes | No |
| edit / update | Every repair | Every repair not handed back | Their own, not handed back |
| destroy | Yes | No | No |
| remove an intake photo | Same as edit / update | Same as edit / update | Same as edit / update |

### Which fields each role writes

| Field | Owner | Counter | Mechanic |
|---|---|---|---|
| bike, customer, mechanic | Yes | Yes | No |
| status | Yes | Yes | Yes |
| promised day, picked up | Yes | Yes | No |
| diagnosis | Yes | Yes | Yes |
| intake photos (add) | Yes | Yes | Yes |
| lines and their charged prices | Yes | Yes | No |
| who took it in | No one: always the account of the session, when the repair is created |

A field outside the role's list is dropped and the rest of the request goes on.

On the page of a repair, its bike and its customer are links only for someone who may open them (owner and counter); a mechanic sees them as plain text.
