require "bundler/setup"
Bundler.require
require "rails/all"

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
          [503, {}, ["FAIL"]]
        end
      }

      mount Blazer::Engine, at: "/"
    end

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
