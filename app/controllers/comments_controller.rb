class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Your comment was added"
      redirect_to post_path(@post)
    else
      @post = Post.find(params[:post_id])
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.new(vote: params[:vote], creator: current_user, voteable: @comment)

    if @vote.save
      flash[:notice] = "Your vote was counted."
    else
      flash[:error] = "Your can only vote on this comment once."
    end

    redirect_to :back
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

end
