require 'test_helper'

class JbTest < ActionDispatch::IntegrationTest
  test 'The template correctly renders a JSON' do
    visit '/posts/1.json'

    json = JSON.parse(page.body)

    assert_equal 'post 1', json['title']
    assert_equal 'user 1', json['user']['name']
    assert_equal 'comment 1', json['comments'][0]['body']
    assert_equal 'comment 2', json['comments'][1]['body']
    assert_equal 'comment 3', json['comments'][2]['body']
  end
end
