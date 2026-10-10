# Gives a user the two protected transports; safe to call more than once
class CreateDefaultTransports
  DEFAULTS = [
    { transport_name: "Veicolo Privato", transport_position: 1, locked: true },
    { transport_name: "Veicolo Aziendale", transport_position: 2, locked: true }
  ].freeze

  def self.call(user)
    user.transports.create!(DEFAULTS) unless user.transports.exists?(locked: true)
  end
end
