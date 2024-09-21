require_relative "boot"

require "rails/all"
require 'webmock'
include WebMock::API

WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)
# Over-the-wire mocking, TODO: move this code to separate initialiser.
stub_request(:post, 'https://api.iterable.com/api/events/track').to_return(
  status: 200,
  body: { msg: 'Event created successfully', code: "Success", params: {} }.to_json,
  headers: { 'Content-Type' => 'application/json' }
)

stub_request(:post, 'https://api.iterable.com/api/email/target').to_return(
  status: 200,
  body: { msg: 'Email sent successfully', code: "Success", params: {} }.to_json,
  headers: { 'Content-Type' => 'application/json' }
)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eventmanager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
