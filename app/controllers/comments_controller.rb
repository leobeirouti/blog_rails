class CommentsController < ApplicationController
  # http_basic_authenticate_with name: "dhh", password: "secret", only: :destroy

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user # Associa o comentário ao usuário logado
    if @comment.save
      redirect_to article_path(@article)
    else
      render :new
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article), status: :see_other
  end

  private
    def comment_params
      params.require(:comment).permit(:body, :status).merge(user_id: current_user.id)
    end
end
