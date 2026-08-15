# Be sure to restart your server when you modify this file.

# HSTS and the "secure" cookie flag only make sense once traffic is served
# over HTTPS. In development/test the app runs over plain HTTP, so forcing
# those would either be ignored or (worse) break the session cookie.
SecureHeaders::Configuration.default do |config|
  config.hsts = Rails.env.production? ? "max-age=31536000; includeSubdomains" : SecureHeaders::OPT_OUT
  config.x_frame_options = "SAMEORIGIN"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "0"
  config.referrer_policy = "strict-origin-when-cross-origin"

  config.cookies = {
    httponly: true,
    secure: Rails.env.production? ? true : SecureHeaders::OPT_OUT,
    samesite: { lax: true }
  }

  # Every asset (fonts, icons, images, JS, CSS) is bundled and served from
  # this app's own origin under /assets - no external CDNs are used.
  config.csp = {
    default_src: %w['self'],
    script_src: %w['self'],
    # Bootstrap's compiled CSS embeds small SVGs as background-image data
    # URIs (form checks, carousel arrows, ...), and the default Rails error
    # pages (public/*.html) ship an inline <style> block.
    style_src: %w['self' 'unsafe-inline'],
    img_src: %w['self' data:],
    font_src: %w['self'],
    connect_src: %w['self'],
    form_action: %w['self'],
    frame_ancestors: %w['self'],
    base_uri: %w['self'],
    object_src: %w['none']
  }
end
