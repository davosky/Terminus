FactoryBot.define do
  factory :reason do
    sequence(:name) { |n| "Motivo #{n}" }
    position { 1 }
    user
  end
end
