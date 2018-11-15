# frozen_string_literal: true

require 'action_dispatch/testing/integration'

puts '* Rendering 10 partials via render_partial'
ActionDispatch::Integration::Session.new(Rails.application).get '/benchmarks.json?n=10'

puts
puts '* Rendering 100 partials via render_partial'
ActionDispatch::Integration::Session.new(Rails.application).get '/benchmarks.json?n=100'

puts
puts '* Rendering 1000 partials via render_partial'
ActionDispatch::Integration::Session.new(Rails.application).get '/benchmarks.json?n=1000'
