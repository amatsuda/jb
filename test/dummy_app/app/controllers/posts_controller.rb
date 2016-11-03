# frozen_string_literal: true
class PostsController < ApplicationController
  def show(id)
    user = User.find 1
    @post = Post.find id
  end

  def hello
    render plain: 'hello'
  end
end
