FactoryBot.define do
  factory :mission_request do
    sequence(:name) { |n| "MR-TT-FVG-FVG-202608180925-#{format('%04d', n)}" }
    departure_date { Date.current }
    return_date { Date.current + 3.days }
    request_date { Date.current }
    reason
    place
    structure
    path
    transport
    user

    trait :free_fields do
      reason { nil }
      place { nil }
      structure { nil }
      path { nil }
      reason_fr { "Corso di formazione" }
      place_fr { "Udine" }
      structure_fr { "Sede regionale" }
      path_fr { "Trieste-Udine" }
      path_lenght_fr { 68.5 }
      highway_cost_fr { 4.5 }
    end
  end
end
