class PostsController < ApplicationController
  def show
    user = User.new 1, 'user 1'
    @post = Post.new 1, user, 'post 1'
    @post.comments = [Comment.new(1, @post, 'comment 1'), Comment.new(2, @post, 'comment 2'), Comment.new(3, @post, 'comment 3')]
  end
end
