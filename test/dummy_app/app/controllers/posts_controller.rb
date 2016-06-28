class PostsController < ApplicationController
  def show
    @post = Post.new 1, 'post 1'
  end
end
