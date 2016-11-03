# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require File.expand_path("../../test/dummy_app/config/environment.rb",  __FILE__)

Bundler.require
require 'test/unit/rails/test_help'
