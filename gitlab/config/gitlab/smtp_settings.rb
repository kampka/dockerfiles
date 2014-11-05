# To enable smtp email delivery for your GitLab instance do next: 
# 1. Rename this file to smtp_settings.rb
# 2. Edit settings inside this file
# 3. Restart GitLab instance
#
if Rails.env.production?
  Gitlab::Application.config.action_mailer.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    address: "{{GITLAB_SMTP_HOST}}",
    port: {{GITLAB_SMTP_PORT}},
    user_name: "{{GITLAB_SMTP_USER}}",
    password: "{{GITLAB_SMTP_PASS}}",
    domain: "{{GITLAB_SMTP_DOMAIN}}",
    authentication: "{{GITLAB_SMTP_AUTHENTICATION}}",
    openssl_verify_mode: "{{GITLAB_SMTP_OPENSSL_VERIFY_MODE}}",
    enable_starttls_auto: {{GITLAB_SMTP_STARTTLS}},
    ca_path: "{{GITLAB_SMTP_CA_PATH}}",
    ca_file: "{{GITLAB_SMTP_CA_FILE}}"
  }
end
