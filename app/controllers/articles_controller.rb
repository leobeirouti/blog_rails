class ArticlesController < ApplicationController
  before_action :authorize_user, only: [ :edit, :update, :destroy ]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: "Artigo criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def authorize_user
    @article = Article.find(params[:id])
    unless @article.user == current_user
      redirect_to articles_path, alert: "Você não tem permissão para modificar este artigo."
    end
  end

  def article_params
    params.require(:article).permit(:title, :body, :status)
  end
end
