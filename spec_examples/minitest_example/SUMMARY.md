## Time elapsed
Slightly above 5 hours (max 15 minutes). Hard to tell excactly because i split it several days. For clarity's sake - I don't count time spent on this summary.

## What I've changed
(unless state otherwise each of following changes is covered in tests)
  - [x] Completed two main tasks
  - [x] Add enum for `state` property in Lead model (in order to unify that with `rejected_reason` property). Also never use 
  - [x] Add counter_cache for leads to `Agency` model (migration and rake task to update counter to current state; doesn't have separate tests). 
    <details close="close">
      <summary>Why</summary>
      I choose this method, because at this state of project I cannot see any drawback of simple counter cache and it will be faster than query with inner join.
      However if keeping counter sync (due to underlying callbacks to make counter work) become issue I would either use periodic job to keep it in sync or just replace it with query mention above.
    </details>
 - [x] Extract all used sql quieries to scopes and enchanced them (eg. change `sort_by` to `order_by`; make 1 query instead of two with `||` operator)
 - [x] Cleaned up `Lead` model (without extracted to different file) in order to make code more readeable, fixed mirror issues:
      * extract percentage calculation to seperate module (lib) to handle DivisionByZero
      * unnecessarly iterating through entrie collection when picking agency 
  - [x] Add validations to `Agent` model in order to make it coherent with db contraints (listed in `schema.rb`)
  - [x] Add test for `Lead#log_state_change` callback
  - [x] Cleaned up `LeadTest.rb` file - separete some test cases, make it simpler when possible (do as little as possible to test). Also refactor factories to inlcude only required properties.
  - [x] Added `mocha` gem in order to stub `Lead#assign_agency` callback during some tests. 

## What I also would like to change (if got more time)
  - [ ] If possible remove callbacks and replace them by service objects. Ideally keep in model only simple validations and relationships (`has_many`, `belongs_to` etc.;  also split tests accordingly).
  - [ ] Consider add or extract some feature tests (only happy path scenario).

<details>
  <summary>How it could looks like?</summary>
  
  ### Services structure
    │   ├── services
    │   │   ├── application_service.rb
                ├── activity_logs
    │   │   │   └── create_service.rb
    │   │   └── leads
    │   │       ├── create_service.rb
    |   |       └── update_service.rb
    │   │       └── send_notifications_service.rb

  ### Example service
```
# application_service.rb
class ApplicationService
  def self.call(...)
    new(...).call
  end
end


# leads/create_service.rb
module Leads
  class CreateService < ApplicationService
    attr_reader :params

    def initialize(params:)
      @params = params.to_h.deep_symbolize_keys
    end

    def call
      lead = assign_agency(params)
      lead.save!
      ::Leads::SendNotificationsService.call(lead:)

      lead
    end

    private

    def assing_agency(params)
      ...
    end
  end
end
```
  
</details>

<details close="close">
  <summary>Why I just didn't start with making `Lead` model less fat?</summary>
      
  1) First make it works
  2) Then make it pretier
  3) Get your back coverd (tests!)
  4) Finally extract that (if it makesjk sense)


</details>

