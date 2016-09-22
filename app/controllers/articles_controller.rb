class ArticlesController < ApplicationController
	include ArticlesHelper
	before_filter :require_login, only: [:new, :create, :edit, :update, :destroy]
	
	def index
		@articles = Article.all
	end

	def show
		@article = Article.find(params[:id])
		@comment = Comment.new
		@comment.article_id = @article.id
	end

	def new
		@article = Article.new
	end

	def create
		@article = Article.new(article_params)
		@article.user = current_user.email
  		@article.save
  		flash.notice = "Article '#{@article.title}' was Saved!"
  		redirect_to article_path(@article)
	end

	def destroy
		@article = Article.find(params[:id])
		if @article.user == current_user.email
			@article.destroy
			flash.notice = "Article '#{@article.title}' has been deleted!"
			redirect_to articles_path
		else
			flash.notice = "Article '#{@article.title}' was not deleted. You can only delete your own articles."
			redirect_to articles_path
		end
	end

	def edit
			@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])
		if @article.user == current_user.email
  			@article.update(article_params)
  			flash.notice = "Article '#{@article.title}' Updated!"
			redirect_to article_path(@article)
		else
			flash.notice = "Article '#{@article.title}' was not updated. You can only edit your own articles."
			redirect_to articles_path
		end
	end
end
