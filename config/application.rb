require "bundler/setup"
Bundler.require

require "rails"

%w(
  active_record/railtie
  action_controller/railtie
  action_mailer/railtie
  action_view/railtie
  sprockets/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

abort "No DATABASE_URL" unless ENV["DATABASE_URL"]

module BlazerSolo
  class Application < Rails::Application
    routes.append do
      # checks app is up, not database or data sources healthy
      # not protected by auth, so do not expose data
      get "health", to: ->(env) { [200, {}, ["OK"]] }

      mount Blazer::Engine, at: "/"
    end

    config.load_defaults Rails::VERSION::STRING.to_f
    config.cache_classes = true
    config.eager_load = true
    config.log_level = :info
    config.secret_key_base = ENV["SECRET_KEY_BASE"] || SecureRandom.hex(30)

    config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"] != "disabled"

    if ENV["RAILS_LOG_TO_STDOUT"] != "disabled"
      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.formatter = config.log_formatter
      config.logger = ActiveSupport::TaggedLogging.new(logger)
    end
  end
end
