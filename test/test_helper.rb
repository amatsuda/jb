# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require File.expand_path("../../test/dummy_app/config/environment.rb",  __FILE__)

Bundler.require

# Load Jbuilder after the app has been initialized so that Jbuilder's Railtie initializer doesn't run,
# because it patches ActionController::API just like Jb does, which would hide failures of Jb's own patch
require 'jbuilder'
ActionView::Template.register_template_handler :jbuilder, JbuilderHandler
require 'action_args'
require 'debug'
require 'test/unit/rails/test_help'
