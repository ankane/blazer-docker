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
      # checks app is up and can connect to database
      # does not check data sources
      # not protected by auth, so do not expose data
      get "health", to: ->(env) {
        if Blazer::Connection.connection.active?
          [200, {}, ["OK"]]
        else
          [503, {}, ["Service Unavailable"]]
        end
      }

      mount Blazer::Engine, at: "/"
    end

    config.cache_classes = true
    config.eager_load = true
    config.log_level = :info
    config.secret_key_base = ENV["SECRET_KEY_BASE"] || SecureRandom.hex(30)
    config.active_record.legacy_connection_handling = false

    config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"] != "disabled"

    if ENV["RAILS_LOG_TO_STDOUT"] != "disabled"
      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.formatter = config.log_formatter
      config.logger = ActiveSupport::TaggedLogging.new(logger)
    end
  end
end
