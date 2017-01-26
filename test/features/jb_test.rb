# frozen_string_literal: true
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
    assert_equal 'metadata layout', json['metadata']
  end


  test 'render_partial returns an empty array for nil-collection' do
    visit '/posts/2.json'

    json = JSON.parse(page.body)

    assert_equal 'post 2', json['title']
    assert_equal [], json['comments']
    assert_equal 'metadata layout', json['metadata']
  end

  test ':plain handler still works' do
    visit '/posts/hello'
    assert_equal 'hello', page.body
  end
end
