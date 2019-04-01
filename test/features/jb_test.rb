# frozen_string_literal: true

require 'test_helper'

class JbTest < ActionDispatch::IntegrationTest
  test 'The template correctly renders a JSON' do
    get '/posts/1.json'

    json = if response.respond_to?(:parsed_body)
      response.parsed_body
    else
      JSON.parse response.body
    end

    assert_equal 'post 1', json['title']
    assert_equal 'user 1', json['user']['name']
    assert_equal 'comment 1', json['comments'][0]['body']
    assert_equal 'comment 2', json['comments'][1]['body']
    assert_equal 'comment 3', json['comments'][2]['body']
  end


  test 'render_partial returns an empty array for nil-collection' do
    get '/posts/2.json'

    json = if response.respond_to?(:parsed_body)
      response.parsed_body
    else
      JSON.parse response.body
    end

    assert_equal 'post 2', json['title']
    assert_equal [], json['comments']
  end

  test ':plain handler still works' do
    get '/posts/hello'
    assert_equal 'hello', response.body
  end
end
