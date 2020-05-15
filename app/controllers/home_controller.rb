class HomeController < ApplicationController
  def top
    @user = User.new
    @posts = Post.all.order(created_at: :desc)
  end
end
