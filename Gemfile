# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in jb.gemspec
gemspec

gem 'rake'
gem 'test-unit-rails'
gem 'action_args'
gem 'jbuilder'
gem 'debug'

if ENV['RAILS_VERSION'] == 'edge'
  gem 'rails', git: 'https://github.com/rails/rails.git', branch: 'main'
elsif ENV['RAILS_VERSION']
  gem 'rails', "~> #{ENV['RAILS_VERSION']}.0"
else
  gem 'rails'
end

if ENV['RAILS_VERSION'] && (ENV['RAILS_VERSION'] != 'edge') && (Gem::Version.new(ENV['RAILS_VERSION']) < Gem::Version.new('8.1'))
  gem 'json', '< 3'
end

gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gem 'loofah', RUBY_VERSION < '2.5' ? '< 2.21.0' : '>= 0'
gem 'selenium-webdriver'
gem 'net-smtp' if RUBY_VERSION >= '3.1'
gem 'benchmark' if RUBY_VERSION >= '4.0'

if RUBY_VERSION >= '3.3'
  gem 'bigdecimal'
  gem 'mutex_m'
end
