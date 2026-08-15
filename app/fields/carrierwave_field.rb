require "administrate/field/base"

class CarrierwaveField < Administrate::Field::Base
  def uploader
    data
  end

  # `uploader.url` points to CarrierWave's storage root, which lives outside
  # `public/` on purpose (uploaded files may be sensitive and must stay behind
  # Devise/Pundit auth). Dashboards that need a working link must pass a named
  # route via `.with_options(download_path: :some_path_helper)`, resolved
  # against the resource, that streams the file through an authenticated
  # controller action.
  def url
    return nil unless uploader.present?
    return uploader.url unless options[:download_path]

    Rails.application.routes.url_helpers.public_send(options[:download_path], resource)
  end

  def filename
    uploader.file.filename if uploader.present?
  end

  def image?
    uploader.present? && uploader.file.content_type.to_s.start_with?("image/")
  end

  def to_s
    filename.to_s
  end
end
