require 'test_helper'

class LeadTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test 'name validation' do
    with_name = build(:lead)
    blank_name = build(:lead, name: ' ')
    nil_name = build(:lead, name: nil)

    assert with_name.valid?
    assert_not blank_name.valid?
    assert_not nil_name.valid?
  end

  test 'email validation' do
    with_email = build(:lead)
    blank_email = build(:lead, email: ' ')
    nil_email = build(:lead, email: nil)

    assert with_email.valid?
    assert_not blank_email.valid?
    assert_not nil_email.valid?
  end

  test 'phone validation' do
    lead_with_phone = build(:lead)
    blank_phone = build(:lead, phone: '')
    nil_phone = build(:lead, phone: nil)

    assert lead_with_phone.valid?
    assert_not blank_phone.valid?
    assert_not nil_phone.valid?
  end

  test 'rejected_reason validation' do
    Lead.rejected_reasons.each_key do |reason|
      lead = build(:lead, rejected_reason: reason)

      assert lead.valid?
    end

    lead_with_nil = build(:lead, rejected_reason: nil)

    assert lead_with_nil.valid?

    assert_raises ArgumentError do
      build(:lead, rejected_reason: 'invalid_reason')
    end
  end

  test 'state validation' do
    Lead.states.each_key do |valid_state|
      lead = build(:lead, state: valid_state)

      assert lead.valid?
    end

    lead_with_nil = build(:lead)

    assert lead_with_nil.valid?

    assert_raises ArgumentError do
      build(:lead, state: 'invalid_state')
    end
  end

  test 'duplicates scope' do
    lead        = create(:lead, phone: '1', email: 'a@a.a', address: 'aaa')
    duplicated  = create(:lead, phone: '1', email: 'a@a.a', address: 'aaa')
    outside_dup_window = create(:lead, phone: '1', email: 'a@a.a', address: 'aaa', created_at: 99.hours.ago)

    result = Lead.duplicates(
      phone: lead.phone,
      email: lead.email,
      city_name: lead.city_name,
      address: lead.address,
      created_at: duplicated.created_at
    )

    assert_includes result, lead
    assert_includes result, duplicated
    assert_not_includes result, outside_dup_window
  end

  test 'previous_leads scope' do
    agency          = create(:agency)
    exceeded_agency = create(:agency, leads_limit: 1)

    Lead.any_instance.stubs(:assign_agency).returns(nil)
    lead = create(:lead, agency:, phone: '1111', email: 'a@a.co', city_name: 'Warszawa')
    create(:lead, phone: '1111', email: 'a@a.co', city_name: 'Warszawa')
    create(:lead, agency: exceeded_agency, phone: '1111', email: 'a@a.co', city_name: 'Warszawa')
    create(:lead, phone: '1111', email: 'a@a.co', city_name: 'Kraków')
    create(:lead, agency:, phone: '9999', email: 'b@b.co', city_name: 'Warszawa')

    result = Lead.previous_leads(phone: '1111', email: 'a@a.co', city_name: 'Warszawa')

    assert_equal [lead], result
  end

  test 'leads from the sonarhome domain should be assigned to the SonarHome agency' do
    create(:agency, city_name: 'Warszawa')

    lead = create(:lead, :with_sonarhome_email)

    assert_equal Lead.states[:new], lead.state
    assert_equal 'SonarHome', lead.agency.name
  end

  test 'should reject leads belongs to agent' do
    create(:agent, phone: '1111', email: 'a@a.co')

    lead_with_agent_phone = create(:lead, phone: '1111')
    lead_with_agent_email = create(:lead, email: 'a@a.co')

    assert_equal Lead.states[:rejected], lead_with_agent_phone.state
    assert_equal Lead.states[:rejected], lead_with_agent_email.state
  end

  test 'should reject duplicated leads' do
    agency = create(:agency, city_name: 'Warszawa')
    create(:lead, phone: '1111', email: 'a@a.co', city_name: 'Warszawa', address: 'aaa')

    dup_lead           = create(:lead, phone: '1111', email: 'a@a.co', city_name: 'Warszawa', address: 'aaa')
    outside_dup_window = create(:lead, phone: '1111', email: 'a@a.co', city_name: 'Warszawa', address: 'aaa',
                                       created_at: 99.hours.ago)

    assert_equal Lead.states[:rejected], dup_lead.state
    assert_equal Lead.rejected_reasons[:duplicate], dup_lead.rejected_reason
    assert_nil dup_lead.agency

    assert_equal Lead.states[:new], outside_dup_window.state
    assert_nil outside_dup_window.rejected_reason
    assert_equal outside_dup_window.agency, agency
  end

  test 'should assign leads from single person to the same agency if possible' do
    create(:agency, city_name: 'Warszawa', leads_limit: 1, leads_count: 1)
    create(:agency, city_name: 'Warszawa')
    agency          = create(:agency, city_name: 'Warszawa')
    previous_lead   = create(:lead, agency:, phone: '1111', email: 'a@a.co', city_name: 'Warszawa', address: 'aaa')

    lead = create(:lead, phone: '1111', email: 'a@a.co', city_name: 'Warszawa', address: 'bbb')

    assert_nil lead.rejected_reason
    assert_equal 'new', lead.state
    assert_equal previous_lead.agency, lead.agency
  end

  test 'should not assign agency that has reached its limit of leads' do
    create(:agency, city_name: 'Warszawa', leads_limit: 1, leads_count: 1)

    lead = create(:lead, city_name: 'Warszawa')

    assert_equal Lead.states[:pending], lead.state
    assert_nil lead.agency
  end

  test 'should assign agency based on city share percentage' do
    agencies = []
    4.times do
      agencies << create(:agency, city_share_percentage: 25, city_name: 'Warszawa')
    end

    20.times do |i|
      lead = create(:lead, phone: "#{i}", email: "t#{i}@t.co", city_name: 'Warszawa')

      assert lead.agency.present?
    end

    agencies.each(&:reload)
    agencies.each do |agency|
      assert_equal 5, agency.leads.size
    end
  end

  test 'should send notification to user after lead creation' do
    Lead.any_instance.stubs(:assign_agency).returns(nil)
    lead          = build(:lead)
    rejected_lead = build(:lead, :state_rejected)

    assert_no_enqueued_emails do
      rejected_lead.save!
    end

    assert_enqueued_email_with LeadMailer, :lead_submission_notification, params: { lead: } do
      lead.save!
    end
  end

  test 'should send notification to assigned agency after lead creation' do
    agency = create(:agency, city_name: 'Warszawa')
    Lead.any_instance.stubs(:assign_agency).returns(nil)
    lead_with_agency    = build(:lead, agency:)
    lead_without_agency = build(:lead)

    assert_enqueued_email_with AgencyMailer, :lead_assigned_notification, params: { lead: lead_with_agency } do
      lead_with_agency.save!
    end

    assert_enqueued_emails 1 do
      lead_without_agency.save!
    end
  end

  test 'should create activity log on state change' do
    lead = create(:lead, :state_pending)

    assert_no_difference('lead.activity_logs.size') do
      lead.update(name: 'Updated Name')
      lead.update(state: Lead.states[:pending])
    end

    assert_difference('lead.activity_logs.size') do
      lead.update(state: 'rejected')
    end

    activity_log = lead.activity_logs.last
    assert_equal 'state_changed', activity_log.action
    assert_equal({ 'state' => 'rejected', 'previous_state' => 'pending' }, activity_log.params)
  end
end
