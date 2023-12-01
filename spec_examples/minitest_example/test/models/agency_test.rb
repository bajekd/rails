require 'test_helper'

class AgencyTest < ActiveSupport::TestCase
  test 'in_city_with_leads_asc scope' do
    agency1 = create(:agency, city_name: 'Warszawa', leads_count: 3)
    agency2 = create(:agency, city_name: 'Warszawa', leads_count: 1)
    agency3 = create(:agency, city_name: 'Warszawa', leads_count: 2)
    create(:agency, city_name: 'Kraków', leads_count: 1)

    in_city_with_leads_asc = Agency.in_city_with_leads_asc(city_name: 'Warszawa')
    assert_equal [agency2, agency3, agency1], in_city_with_leads_asc
  end
end
