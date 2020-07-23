class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @comment = current_user.comments.build(body: params[:comment][:body], post_id: params[:post_id])
    if @comment.save
      redirect_to post_path(@comment.post), flash: { success: t(".flash.コメントしました") }
    else
      @post = Post.find(params[:post_id])
      render "posts/show"
    end
  end

  def destroy
  end
end
