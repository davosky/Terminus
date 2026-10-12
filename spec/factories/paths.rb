FactoryBot.define do
  factory :path do
    user
    sequence(:name) { |n| "Percorso #{n}" }
    lenght { 12.5 }
    sequence(:position) { |n| n }
  end
end
