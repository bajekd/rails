# README

At SonarHome our aim is to help people sell their apartments. We do that by connecting apartment owners with real estate agents who can help them with the sale.

This demo application is a heavily simplified and stripped-down version of the real process and the task you're about to do resembles the tasks we do on a daily basis.

The process looks like this:

- user wants to sell their apartment and submits their contact details (phone and email) to us
- this creates a new `Lead` in our system
- the lead is then assigned to one of our partners (`Agency`) in the given city based on a set of rules

The rest of the process is not relevant to this task.

## Your task

The existing code works correctly, but there are issues with it. We'll let you make suggestions on how to improve it.

However, your main task is to add 2 new rules to the agency assignment logic (`Lead#assign_agency`):

### Rule 1

- user submits a new lead
- but they previously submitted other leads with the same phone or email
- in that case we always want to assign this lead to an agency that was assigned to the previous lead
- but only if:
  - `lead.city_name` matches previous leads and `agency.city_name`
  - agency limits are not exceeded

Business context: we don't want a single person to be assigned to different agencies.

### Rule 2

- when user (identified by phone and email) submits more than 1 lead for the same address within 24 hours:
  - we should keep only 1 lead and reject the duplicates

Business context: we don't want to spam agencies with the same lead.

* * *

## What you're allowed to do

- you're allowed (and encouraged) to clean up, refactor and reorganize the existing code
- you're allowed refactor tests

## What you're not allowed to do

- do not change the behavior of the existing code
- do not add any UI or controllers - we're only interested in the business logic part

The number of changes you can theoretically do here is unlimited, so we ask you to spend no more than 4-5 hours on this task.

When you're done with the task, send it back to us as a zip file.

Please include the information on how long it took you to complete it.

Some brief notes on:

- how you approached this problem
- what technical choices you made and why
- what you would do differently if you had more time

...are highly appreciated.

## Questions?

If you have any questions, feel free to contact us.

Good luck!
