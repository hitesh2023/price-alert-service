require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module PriceAlertService
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.autoload_paths << Rails.root.join('lib')
    config.active_job.queue_adapter = :sidekiq
  end
end
