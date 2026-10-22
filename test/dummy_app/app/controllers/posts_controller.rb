# frozen_string_literal: true
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show(id)
    @post = Post.find id
  end

  def mixed
    @items = [Post.find(1), User.find(1)]
  end

  def rendered_to_string
    @post = Post.find 1
    render plain: render_to_string(:show)
  end

  def hello
    render plain: 'hello'
  end
end
