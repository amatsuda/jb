class PostsController < ApplicationController
  def show
    user = User.new 1, 'user 1'
    @post = Post.new 1, user, 'post 1'
  end
end
