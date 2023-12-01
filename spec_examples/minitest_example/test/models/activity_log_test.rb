require 'test_helper'

class ActivityLogTest < ActiveSupport::TestCase
  test 'lead validation' do
    lead = create(:lead)
    activity_log_with_lead = build(:activity_log, lead:)
    activity_log_without_lead = build(:activity_log, lead: nil)

    assert activity_log_with_lead.valid?
    assert_not activity_log_without_lead.valid?
  end
end
