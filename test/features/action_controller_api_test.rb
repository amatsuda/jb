# frozen_string_literal: true
require 'test_helper'

if Rails::VERSION::MAJOR >= 5

class ActionControllerAPITest < ActionDispatch::IntegrationTest
  test 'The template correctly renders a JSON' do
    visit '/api/posts/1.json'

    json = JSON.parse(page.body)

    assert_equal 'post 1', json['title']
  end
end

end
