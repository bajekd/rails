FactoryBot.define do
  factory :agent do
    agency
    name { 'John' }
    sequence(:phone) { |n| "1234#{n}" }
    sequence(:email) { |n| "agent#{n}@example.com" }
  end
end
