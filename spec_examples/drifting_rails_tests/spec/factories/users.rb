FactoryBot.define do
  factory :user do
    first_name 'John'
    last_name 'Doe'
    email 'john.doe@example.com'
    active true

    # trait :inactive_user do
    #   active false
    # end

    # trait :with_friends do
    #  firends { create_lists(:user, 3)}
    # end
  end

  factory :random_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    active true
  end
end
