# User Stories

The roles I found in the description are **counter staff**, **mechanic**, **shop owner**, and **visitor**.

Customers are part of the information stored by the system, but I did not treat them as users of the internal system because the description never says that they use it directly.

## 1. Intake

**Story 1**

As a counter staff member, I want to record a customer's name and phone number when they drop off a bike, so that we know who to contact about the repair.

**Story 2**

As a counter staff member, I want to record the bike's model and serial number, so that we can distinguish it from other similar bikes in the shop.

**Story 3**

As a counter staff member, I want to add photos of the bike when it arrives, so that there is a record of its condition before any work is done.

**Story 4**

As a counter staff member, I want to record the promised completion date when a bike is dropped off, so that the shop knows when the repair is expected to be ready.

## 2. Diagnosis and quote

### Story that is too big

**BIG STORY — intentionally too big**

> As a mechanic, I want to process a repair from diagnosis to completion, so that the bike can move from intake to pickup.

This story is too big because it includes several different needs. I split it by value into Stories 5, 6 and 7.

**Story 5 — split from the big story**

As a mechanic, I want to write a diagnosis and select the jobs the bike needs from the price list, so that the shop can prepare a quote for the customer.

**Story 6 — split from the big story**

As a counter staff member, I want to record whether the customer approved or declined a quote, so that the mechanic knows whether the repair can continue.

**Story 7 — split from the big story**

As a mechanic, I want to mark a repair as finished, so that the counter staff knows the bike is ready for pickup.

## 3. Doing the work

**Story 8**

As a mechanic, I want to record a different price for a job on a specific repair, so that the amount charged can reflect a discount or a job that was easier than expected.

**Story 9**

As a mechanic, I want to see the previous repairs made to a bike, so that I know what has been done to it before even if the bike has changed owners.

## 4. Status and pickup

**Story 10**

As a counter staff member, I want to check the current status of a bike in the shop, so that I can answer a customer who calls to ask if their bike is ready.

**Story 11**

As the shop owner, I want to see repairs that are past their promised completion date, so that I can notice delays before the customer calls about them.

**Story 12**

As a counter staff member, I want to mark a bike as picked up, so that it no longer appears as waiting in the shop.

**Story 13**

As a counter staff member, I want to return a bike without repair work when its quote was declined, so that the customer can take it back without the proposed work being done.

## 5. Pricing and privacy

**Story 14**

As the shop owner, I want the price charged for each job on a repair to stay the same after the price list changes, so that old repair records do not change when prices go up.

**Story 15**

As the shop owner, I want customers' repair information to stay private, so that people cannot see other customers' repairs.

**Story 16**

As a visitor, I want to see the current job price list on the public website, so that I can check what a service costs without calling the shop.

# Acceptance Criteria

## Story 5 — Write a diagnosis and select jobs

Done when:

- The diagnosis can be recorded as readable free text.
- One or more jobs from the shop's price list can be selected for the repair.
- Each selected job shows the price being quoted for that repair.

## Story 6 — Record the customer's decision

Done when:

- A quote can be recorded as approved or declined.
- A repair with a declined quote does not show an option to start the work.
- After an approved quote is recorded, the repair can move to work in progress.

## Story 9 — See the bike's repair history

Done when:

- The repair history belongs to the bike, not to its current owner.
- Each previous repair shows its diagnosis, jobs performed and date.
- If the bike has no previous repairs, the screen says so instead of showing an empty list.

## Story 10 — Check if a bike is ready

Done when:

- The counter staff can find a bike that is currently in the shop.
- The current repair status and promised completion date are visible.
- If no matching bike is found, the screen says so instead of showing a blank result.