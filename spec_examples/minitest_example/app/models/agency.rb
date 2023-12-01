class Agency < ApplicationRecord
  has_many :agents
  has_many :leads

  def self.sonarhome_agency
    Agency.find_or_create_by!(name: 'SonarHome')
  end

  scope :in_city_with_leads_asc, lambda { |city_name:|
    where(city_name:).order(:leads_count)
  }
end
