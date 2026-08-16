class ValidatorSignatureUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w[png jpg jpeg]
  end

  def content_type_allowlist
    %w[image/png image/jpeg]
  end

  def size_range
    1..2.megabytes
  end
end
