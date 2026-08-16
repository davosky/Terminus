FactoryBot.define do
  factory :vehicle do
    name { "Panda" }
    producer { Faker::Vehicle.make }
    sequence(:licence_plate) { |n| "AA#{n.to_s.rjust(3, '0')}BB" }
    cost_per_km { 0.35 }
    position { 1 }
    user
  end
end
