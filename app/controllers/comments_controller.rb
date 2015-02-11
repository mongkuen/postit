class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Your comment was added"
      redirect_to post_path(@post)
    else
      @post = Post.find_by(slug: params[:post_id])
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    votes = @comment.votes.where(creator: current_user)
    if votes.size == 0
      @vote = Vote.create(vote: params[:vote], voteable: @comment, creator: current_user)
    elsif votes.first[:vote].to_s == params[:vote]
      @vote = votes.first.update(vote: nil)
    else
      @vote = votes.first.update(vote: params[:vote])
    end

    respond_to do |format|
      format.html {
        flash[:notice] = "Your vote was counted."
        redirect_to :back
      }

      format.js {}
    end

  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

end
