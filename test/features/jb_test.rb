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

  test 'render_partial returns an Array for a collection of different kinds of objects' do
    get '/posts/mixed.json'

    json = if response.respond_to?(:parsed_body)
      response.parsed_body
    else
      JSON.parse response.body
    end

    assert_equal [{'title' => 'post 1'}, {'name' => 'user 1'}], json['items']
  end

  test 'Fragment-caching the result' do
    # First request for setting the cache, and second request for fetching the cache
    2.times do
      get '/posts.json'

      json = if response.respond_to?(:parsed_body)
        response.parsed_body
      else
        JSON.parse response.body
      end

      assert_equal 'post 1', json[0]['title']
      assert_equal 'post 2', json[1]['title']
    end
  end

  test 'render_to_string returns a JSON String' do
    get '/posts/rendered_to_string.json'

    json = JSON.parse response.body

    assert_equal 'post 1', json['title']
    assert_equal ['comment 1', 'comment 2', 'comment 3'], json['comments'].map {|c| c['body'] }
  end

  test 'render template: from a jb template returns the rendered object, not a JSON String' do
    get '/posts/nested.json'

    json = JSON.parse response.body

    assert_equal 'post 1', json['post']['title']
  end

  test 'render template: from a non-jb template returns a JSON String' do
    get '/posts/embedded'

    json = JSON.parse response.body

    assert_equal 'post 1', json['title']
  end

  # ActionController::API doesn't support layouts
  unless ENV['API'] == '1'
    test 'a non-jb layout yields a JSON String' do
      get '/posts/with_layout.json'

      json = JSON.parse response.body

      assert_equal 'post 1', json['data']['title']
    end
  end

  test 'a Jbuilder collection partial is not affected' do
    get '/posts/jbuilder.json'

    json = JSON.parse response.body

    assert_equal ['comment 1', 'comment 2', 'comment 3'], json['comments'].map {|c| c['body'] }
  end

  test ':plain handler still works' do
    get '/posts/hello'
    assert_equal 'hello', response.body
  end
end
