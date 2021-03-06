if Rails.env.production? and ENV["ENABLE_SECURE_HEADERS"]
  SecureHeaders::Configuration.default do |config|
    config.cookies = {
      secure: true, # mark all cookies as "Secure"
      httponly: true, # mark all cookies as "HttpOnly"
      samesite: {
        lax: true # mark all cookies as SameSite=lax
      }
    }

    # Add "; preload" and submit the site to hstspreload.org for best protection.
    config.hsts = "max-age=#{1.week.to_i}"
    config.x_frame_options = "DENY"
    config.x_content_type_options = "nosniff"
    config.x_xss_protection = "1; mode=block"
    config.x_download_options = "noopen"
    config.x_permitted_cross_domain_policies = "none"
    config.referrer_policy = %w(origin-when-cross-origin strict-origin-when-cross-origin)
    config.csp = {
      # "meta" values. these will shape the header, but the values are not included in the header.
      preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.

      # directive values: these values will directly translate into source directives
      default_src: %w('self'),
      base_uri: %w('self'),
      block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
      child_src: %w(www.youtube.com 'self'), # if child-src isn't supported, the value for frame-src will be set.
      connect_src: %w(wss: 'self'),
      font_src: %w('self' data:),
      form_action: %w('self'),
      frame_ancestors: %w(*), # for iframes / external embeds
      img_src: %w('self' *.maps.api.here.com data:),
      manifest_src: %w('self'),
      media_src: %w('self'),
      object_src: %w('self'),
      sandbox: %w(allow-same-origin allow-forms allow-scripts allow-modals allow-popups allow-presentation), # true and [] will set a maximally restrictive setting
      plugin_types: %w(application/x-shockwave-flash),
      script_src: %w('self' 'unsafe-inline'),
      style_src: %w('self' 'unsafe-inline'),
      worker_src: %w('self'),
      upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
      report_uri: %w(https://decidim.report-uri.com/r/d/csp/reportOnly)
    }
  end
end
