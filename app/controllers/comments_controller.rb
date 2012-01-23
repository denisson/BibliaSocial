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
	@comment = params[:comment]
	@comment[:user] = current_user
	@comment[:texto_html] = Comment.formatar_links(@comment[:texto])
	@comment[:texto_html] = Comment.formatar_html(@comment[:texto_html])
	@comment = @versiculo.comments.create(@comment)
	if @comment.errors.empty?
		create_referencias
		create_links
	else
		flash[:alert] = @comment.errors.inspect
	end
	redirect_to versiculo_comments_path(@versiculo)
  end
  
  def create_referencias
	Comment.get_referencias.each do |referencia|
		referencia[:user] = current_user
		referencia[:versiculo] = @versiculo
		referencia[:comment] = @comment
		@comment.referencias.create(referencia)
	end
  end
  
  def create_links
	Comment.get_links.each do |link|
		page = Nokogiri::HTML(open(link))
		p page.inspect
		video_link = page.css('meta[property="og:video"]').first
		if video_link != nil
			thumb_url = page.css('meta[property="og:image"]').first.attribute('content').content
			titulo = page.css('meta[property="og:title"]').first.attribute('content').content
			player_url = video_link.attribute('content').content
			@comment.videos.create({:thumb_url => thumb_url, :link_url => link, :player_url => player_url, :titulo => titulo, :user => current_user, :versiculo => @versiculo, :comment => @comment})
		else
			@comment.links.create({:url => link, :user => current_user, :versiculo => @versiculo, :comment => @comment})
		end		
	end
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



