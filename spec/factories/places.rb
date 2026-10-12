FactoryBot.define do
  factory :place do
    user
    sequence(:name) { |n| "Luogo #{n}" }
    sequence(:position) { |n| n }
  end
end
