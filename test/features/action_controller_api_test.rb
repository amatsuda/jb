# frozen_string_literal: true
require 'test_helper'

if Rails::VERSION::MAJOR >= 5

class ActionControllerAPITest < ActionDispatch::IntegrationTest
  test 'The template correctly renders a JSON' do
    get '/api/posts/1.json'

    json = response.parsed_body

    assert_equal 'post 1', json['title']
  end
end

end
