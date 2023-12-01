require 'test_helper'

class AgentTest < ActiveSupport::TestCase
  test 'agency validation' do
    agent_with_agency = build(:agent)
    agent_without_agency = build(:agent, agency: nil)

    assert agent_with_agency.valid?
    assert_not agent_without_agency.valid?
  end

  test 'phone validation' do
    agent = create(:agent, phone: '1234', email: 'u@t.co')

    blank_phone = build(:agent, phone: ' ')
    nil_phone = build(:agent, phone: nil)
    duplicate_phone = build(:agent, phone: '1234')

    assert agent.valid?
    assert blank_phone.valid?
    assert nil_phone.valid?
    assert_not duplicate_phone.valid?
  end

  test 'email validation' do
    agent = create(:agent, phone: '1234', email: 'u@t.co')

    blank_email = build(:agent, email: ' ')
    nil_email = build(:agent, email: nil)
    duplicate_email = build(:agent, email: 'u@t.co')

    assert agent.valid?
    assert blank_email.valid?
    assert nil_email.valid?
    assert_not duplicate_email.valid?
  end

  test 'find_by_phone_or_email scope' do
    agent_with_phone = create(:agent, phone: '1111')
    agent_with_email = create(:agent, email: 'a@a.co')
    agent = create(:agent, phone: '9999', email: 'b@b.co')

    result = Agent.find_by_phone_or_email(phone: '1111', email: 'a@a.co')

    assert_equal 2, result.size
    assert_includes result, agent_with_phone
    assert_includes result, agent_with_email
    assert_not_includes result, agent
  end
end
