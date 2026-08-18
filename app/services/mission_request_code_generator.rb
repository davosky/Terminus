class MissionRequestCodeGenerator
  def self.call(user:)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    "MR-#{initials}-#{user.region}-#{user.province}-#{timestamp}-#{sequence}"
  end

  private

  attr_reader :user

  def initials
    "#{user.first_name.to_s.first}#{user.last_name.to_s.first}".upcase
  end

  def timestamp
    Time.current.strftime("%Y%m%d%H%M")
  end

  def sequence
    format("%04d", MissionRequest.count + 1)
  end
end
