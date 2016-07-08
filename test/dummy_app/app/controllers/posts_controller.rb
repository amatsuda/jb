class PostsController < ApplicationController
  def show
    user = User.find 1
    @post = Post.find params[:id]
  end

  def hello
    render plain: 'hello'
  end
end
