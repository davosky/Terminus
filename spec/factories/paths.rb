FactoryBot.define do
  factory :path do
    sequence(:name) { |n| "Percorso #{n}" }
    lenght { 12.5 }
    highway_cost { 3.5 }
    position { 1 }
    user
  end
end
