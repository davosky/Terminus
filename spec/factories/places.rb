FactoryBot.define do
  factory :place do
    sequence(:name) { |n| "Luogo #{n}" }
    position { 1 }
    user
  end
end
