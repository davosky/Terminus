CarrierWave.configure do |config|
  config.storage = :file
  config.root = Rails.root.join(Rails.env.test? ? "tmp/storage" : "storage").to_s
  config.cache_dir = "uploads/tmp"
end

# Global allowlist applied to every uploader unless overridden per-class.
CarrierWave::Uploader::Base.class_eval do
  def extension_allowlist
    %w[png pdf]
  end

  def content_type_allowlist
    %w[image/png application/pdf]
  end
end
