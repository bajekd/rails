namespace :counters do
  desc 'Reset the leads_count counter cache for all agencies'
  task update: :environment do
    Agency.find_each do |agency|
      Agency.reset_counters(agency.id, :leads)
    end

    puts 'Leads count cache reset complete.'
  end
end
