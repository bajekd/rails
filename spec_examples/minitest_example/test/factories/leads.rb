FactoryBot.define do
  factory :lead do
    name { 'Mystring' }
    email { 'someone@example.com' }
    phone { '1234' }

    trait :state_pending do
      state { Lead.states[:pending] }
    end

    trait :state_rejected do
      state { Lead.states[:rejected] }
    end

    trait :state_new do
      state { Lead.states[:new] }
    end

    trait :with_sonarhome_email do
      email { 'someone@sonarhome.pl' }
    end
  end
end
