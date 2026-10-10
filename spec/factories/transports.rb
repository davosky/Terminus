FactoryBot.define do
  factory :transport do
    user
    sequence(:transport_name) { |n| "Trasporto #{n}" }
    sequence(:transport_position) { |n| n }

    trait :locked do
      locked { true }
    end
  end
end
