# Decisions

These are questions I would ask the owner because the description does not answer them and the answer would change the model.

## 1. Do quick repairs also need customer approval?

The owner says that sometimes a repair is something simple like a flat tyre and the bike leaves the same afternoon. Other times they inspect the bike, call the customer with a price and wait for them to say yes before doing the work. It is not clear whether quick repairs also need explicit approval.

**Assumption I made:** every repair goes through diagnosis and customer approval before moving to `in_progress`, even if the approval happens very quickly.

**If the answer were that approval can be skipped:** the lifecycle would also allow `diagnosed -> in_progress` for repairs that do not need a separate approval step.

## 2. Does the shop keep track of the current owner of a bike?

The owner says that people sometimes sell their bikes and that the second owner should still be able to know what was repaired before. However, the description does not say that the shop needs to keep a record of the bike's current owner.

**Original assumption (Lab 3):** the system does not store a bike's current owner. Each repair records the customer who brought the bike in for that visit, while the repair history stays connected to the bike itself.

**Revised in Lab 8:** the counter needs to create a bike straight from its owner's page with the owner already selected, and needs to be stopped from deleting a customer who still owns a bike. Both need a real, required `bikes.customer_id`, so I added it. `repairs.customer_id` still exists on its own, since whoever drops the bike off for a specific repair is not always its owner (family member, previous owner, etc.). If the bike is later sold, the shop updates `bikes.customer_id` to the new owner and the old repairs stay linked to the bike either way.

## 3. Who is allowed to charge less than the listed price?

The owner says that sometimes the shop charges less than the price list because someone is a regular customer or because a job was easier than expected. The description does not say who is allowed to make that decision.

**Assumption I made:** a mechanic can change `price_charged` for a job on a specific repair without a separate approval being recorded.

**If the answer were that the shop owner has to approve discounts:** `repair_jobs` would need an `approved_by_id` to record who authorized the lower price.

## 4. Which role does a new account get by default? (Lab 11)

Every account has a role (`owner`, `mechanic` or `counter`), and the sign-up page does not let anyone choose it, so a new account needs a default. The default should be the role that can do the least, so that an account nobody has reviewed yet cannot see or change more than it should.

**Assumption I made:** the default is `mechanic`. The owner runs everything, including the price list and the staff. The counter takes bikes in, so it reads every repair and talks to every customer. A mechanic only works on the repairs assigned to them, and they are assigned through the member of the staff joined to the account. A new account is not joined to anyone, so as a mechanic it has no repairs of its own and reads none, which is less than the counter can see.

**If the answer were that the counter should be the default:** a stranger who signs up would read every repair and every customer's name from the start, which is exactly what the owner asked to keep closed.