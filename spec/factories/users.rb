FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    password { "pAssword1234567" }
    password_confirmation { "pAssword1234567" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    admin { false }
    manager { false }
    regular { true }

    trait :admin do
      admin { true }
      regular { false }
    end

    trait :manager do
      manager { true }
      regular { false }
    end
  end
end
