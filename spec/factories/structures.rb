FactoryBot.define do
  factory :structure do
    sequence(:name) { |n| "Struttura #{n}" }
    position { 1 }
    user
  end
end
