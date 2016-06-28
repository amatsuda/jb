# Be sure to restart your server when you modify this file.
#
# This file contains migration options to ease your Rails 5.0 upgrade.
#
# Read the Rails 5.0 release notes for more info on each option.

# Configure SSL options to enable HSTS with subdomains. Previous versions had false.
Rails.application.config.ssl_options = { hsts: { subdomains: true } }
