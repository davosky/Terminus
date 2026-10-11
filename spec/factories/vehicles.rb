FactoryBot.define do
  factory :vehicle do
    user
    producer { "Fiat" }
    sequence(:name) { |n| "Modello #{n}" }
    sequence(:licence_plate) { |n| "AB#{n.to_s.rjust(3, '0')}CD" }
    power { "Benzina" }
    cost_per_km { 0.45 }
    sequence(:position) { |n| n }
  end
end
