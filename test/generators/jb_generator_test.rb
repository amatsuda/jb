# frozen_string_literal: true

require 'test_helper'
require 'rails/generators/test_case'
require 'generators/rails/jb_generator'

class JbGeneratorTest < Rails::Generators::TestCase
  tests Rails::Generators::JbGenerator
  destination File.expand_path('../../tmp', __dir__)
  setup :prepare_destination

  test 'index and show render the same attributes, timestamps, and url' do
    run_generator %w(post title:string user:references)

    assert_file 'app/views/posts/index.json.jb', <<~JB
      @posts.map do |post|
        {
          id: post.id,
          title: post.title,
          user_id: post.user_id,
          created_at: post.created_at,
          updated_at: post.updated_at,
          url: post_url(post, format: :json)
        }
      end
    JB
    assert_file 'app/views/posts/show.json.jb', <<~JB
      {
        id: @post.id,
        title: @post.title,
        user_id: @post.user_id,
        created_at: @post.created_at,
        updated_at: @post.updated_at,
        url: post_url(@post, format: :json)
      }
    JB
  end

  test 'no timestamps with --no-timestamps' do
    run_generator %w(post title:string --no-timestamps)

    %w(index show).each do |view|
      assert_file "app/views/posts/#{view}.json.jb" do |content|
        assert_no_match(/created_at|updated_at/, content)
      end
    end
  end

  test "password digest doesn't expose password nor password_confirmation" do
    run_generator %w(user name:string password:digest)

    %w(index show).each do |view|
      assert_file "app/views/users/#{view}.json.jb" do |content|
        assert_no_match(/password/, content)
      end
    end
  end

  if Rails::VERSION::MAJOR >= 6
    test 'attachment, attachments, and rich_text are rendered as JSON friendly values' do
      run_generator %w(post avatar:attachment photos:attachments content:rich_text)

      assert_file 'app/views/posts/show.json.jb' do |content|
        assert_match 'avatar: (url_for(@post.avatar) if @post.avatar.attached?),', content
        assert_match 'photos: @post.photos.map {|photo| {id: photo.id, url: url_for(photo)} },', content
        assert_match 'content: @post.content.to_s,', content
      end
      assert_file 'app/views/posts/index.json.jb' do |content|
        assert_match 'avatar: (url_for(post.avatar) if post.avatar.attached?),', content
        assert_match 'photos: post.photos.map {|photo| {id: photo.id, url: url_for(photo)} },', content
        assert_match 'content: post.content.to_s,', content
      end
    end
  end
end
