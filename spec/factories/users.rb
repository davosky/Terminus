FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "utente#{n}" }
    email { Faker::Internet.unique.email }
    password { "pAssword1234567" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender { "A" }
    region { "FVG" }
    province { "TS" }
    institute { "Istituto" }
    office { "Ufficio" }

    trait :admin do
      admin { true }
    end
  end
end
