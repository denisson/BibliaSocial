class CommentsController < ItensController
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

      string_item = params[:comment][:string_item]
      texto_comment = params[:comment][:texto]
      hash_item = {:user => current_user, :versiculo => @versiculo}

      if Referencia.pode_ser? string_item
        model_item = Referencia
        hash_item[:ref] = string_item
      elsif Link.pode_ser? string_item
        model_item = Link
        hash_item[:url] = string_item
      else
        model_item = Comment
        hash_item[:texto] = texto_comment
      end

      if model_item != Comment && texto_comment != ""
        @item = model_item.criar_com_comment(hash_item, texto_comment)
      else
        @item = model_item.criar(hash_item)
      end

      if @item == nil
        flash[:alert] = "Não foi possível publicar este conteúdo! Tente novamente em instantes."
      elsif @item.errors.any?
        flash[:alert] = @item.errors.inspect
      end

      respond_with(@item, :layout => !request.xhr?)
  end

  def model
    Comment
  end

#  def destroy
#    @versiculo = Versiculo.find(params[:versiculo_id])
#    @comment = @versiculo.comments.find(params[:id])
#
#    if @comment and @comment.user == current_user
#      @comment.destroy
##      redirect_to versiculo_atividades_path(@versiculo), :notice => "O comentário foi excluído"
##    else
##      redirect_to versiculo_atividades_path(@versiculo), :notice => "Você não tem permissão para excluir este Comentário"
#
#    end
#    respond_with(@comment, :layout => !request.xhr?)
#   # if @comment.errors.any?
#    #  render :json => @comment.errors, :status => :unprocessable_entity
#   # else
#   #   render :nothing => true
#   # end
#  end
end