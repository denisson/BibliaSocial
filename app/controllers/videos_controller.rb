class VideosController < ApplicationController

  def index
	@versiculo = Versiculo.find(params[:versiculo_id])
	@videos = @versiculo.videos
	@versiculo.comments.build
	@video = Video.new
    respond_to do |format|
      format.html
      format.js
    end
  end
  
 def create
	@versiculo = Versiculo.find(params[:versiculo_id])
	comment = params[:video][:comment]
	if comment[:texto] != ""
		@comment = Comment.create_comment_link(current_user, @versiculo, comment[:texto], params[:video][:link_url])
		if @comment.errors.any?
			flash[:alert] = @comment.errors.inspect
		end
	else
		link_ou_video = Link.create_link current_user, @versiculo, params[:video][:link_url]
	end
	
	redirect_to versiculo_videos_path(@versiculo)
  end
end


