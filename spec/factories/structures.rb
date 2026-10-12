FactoryBot.define do
  factory :structure do
    user
    sequence(:name) { |n| "Struttura #{n}" }
    sequence(:position) { |n| n }
  end
end
