# frozen_string_literal: true
require_relative 'boot'

# require logger before rails or Rails 6 fails to boot
require 'logger'

require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)
require "jb"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.hosts << 'www.example.com' if config.respond_to? :hosts
  end
end
