FactoryBot.define do
  factory :transport do
    sequence(:name) { |n| "Trasporto #{n}" }
    position { 1 }
    user
  end
end
