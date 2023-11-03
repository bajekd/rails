class CommentsController < ApplicationController
  before_action :set_commentable

  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.build(comments_params)
    @comment.user = current_user
    if @comment.save
      msg_notice = 'Comment created'
      if @commentable.model_name == 'Comment'
        redirect_to @commentable.commentable, notice: msg_notice
      else
        redirect_to @commentable, notice: msg_notice
      end
    else
      render :new
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      if @commentable.model_name == 'Comment'
        redirect_to @commentable.commentable, notice: 'Comment deleted'
      else
        redirect_to @commentable, notice: 'Something went wrong!'
      end
    else
      redirect_to @commentable, notice: 'Something went wrong!'
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    if params[:post_id].present?
      @commentable = Post.find(params[:post_id])
    elsif params[:comment_id].present?
      @commentable = Comment.find(params[:comment_id])
    end
  end
end