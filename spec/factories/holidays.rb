FactoryBot.define do
  # Di default una richiesta in attesa di approvazione.
  factory :holiday do
    start_date { Date.current }
    end_date { Date.current + 2.days }
    sequence(:reason) { |n| "Ferie #{n} al mare" }
    requested { true }
    user

    trait :approved do
      request_approved { true }
    end

    trait :rejected do
      request_approved { false }
      rejection_motivation { "Periodo di chiusura contabile" }
    end

    # Inserite direttamente (dal direttore o da chi non deve richiederle).
    trait :direct do
      requested { false }
      request_approved { true }
    end
  end
end
