if ENV['SMTP_ADDRESS'].present?
  ActionMailer::Base.smtp_settings = {
    authentication: ENV.fetch('SMTP_AUTHENTICATION', 'login').to_sym,
    address: ENV['SMTP_ADDRESS'],
    port: ENV.fetch('SMTP_PORT', 587),
    domain: ENV.fetch('SMTP_DOMAIN', 'localhost'),
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    enable_starttls_auto: ENV.fetch('SMTP_STARTTLS', 'true') == 'true'
  }
end
