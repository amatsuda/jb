require 'test_helper'

class JbTest < ActionDispatch::IntegrationTest
  test 'The controller works without engines' do
    visit '/posts/1.json'

    json = JSON.parse(page.body)

    assert_equal 'post 1', json['title']
    assert_equal 'user 1', json['user']['name']
  end
end
