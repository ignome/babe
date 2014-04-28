class CommentsController < ApplicationController
  
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)

    @comment.user_id = current_user.id
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :subject_type, :subject_id)
  end
end
