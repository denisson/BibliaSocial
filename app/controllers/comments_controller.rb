
require 'open-uri'
class CommentsController < ApplicationController
  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@comment = Comment.new
	@comments = @versiculo.comments
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @versiculo = Versiculo.find(params[:versiculo_id])
	@comment = Comment.criar({:user => current_user, :versiculo => @versiculo, :texto => params[:comment][:texto]})
	if @comment.errors.any?
		flash[:alert] = @comment.errors.inspect
	end
	redirect_to versiculo_atividades_path(@versiculo) + "?filtro=Comment"
  end

  def destroy
	@versiculo = Versiculo.find(params[:versiculo_id])
    @comment = @versiculo.comments.find(params[:id])

	if @comment and @comment.user == current_user
		@comment.destroy
		redirect_to versiculo_comments_path(@versiculo), :notice => "O comentário foi excluído"
	else
		redirect_to versiculo_comments_path(@versiculo), :notice => "Você não tem permissão para excluir este Comentário"
	end
  end
end