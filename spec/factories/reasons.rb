FactoryBot.define do
  factory :reason do
    user
    sequence(:name) { |n| "Motivo #{n}" }
    sequence(:position) { |n| n }
  end
end
