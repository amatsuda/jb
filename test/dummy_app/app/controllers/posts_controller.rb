# frozen_string_literal: true
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show(id)
    @post = Post.find id
  end

  def hello
    render plain: 'hello'
  end
end
