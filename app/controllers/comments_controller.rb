class CommentsController < ItensController

  def model
    Comment
  end

  def create
      if params[:versiculo_id] != nil
        @versiculo = Versiculo.find(params[:versiculo_id])
        @mostrar_versiculo = false
      else
        @mostrar_versiculo = true
      end

      string_item = params[:comment][:string_item]
      texto_comment = params[:comment][:texto]
      item_type = params[:comment][:item_type]
      hash_item = {:user => current_user, :versiculo => @versiculo}

      if item_type == "Referencia" and string_item != '' # and Referencia.pode_ser? string_item
        model_item = Referencia
        hash_item[:ref] = string_item
      elsif item_type == "Link"  and string_item != ''# Link.pode_ser? string_item
        model_item = Link
        hash_item[:url] = string_item
      elsif item_type == "Video" and string_item != ''
        model_item = Video
        hash_item[:url] = string_item
      else
        model_item = Comment
        hash_item[:texto] = texto_comment
      end

      #Não é um comentário, mas tem um Comentário atrelado
      if model_item != Comment && texto_comment != ""
        @item = model_item.criar_com_comment(hash_item, texto_comment)
      else
        @item = model_item.criar(hash_item)
      end
      @versiculo.reload if @versiculo != nil

      if @item == nil
        flash[:alert] = "Não foi possível publicar este conteúdo! Tente novamente em instantes."
        respond_with(@item, :layout => !request.xhr?) do |format|
          format.js {render :partial => "partials/show_message"}
        end
      elsif @item.errors.any?
        flash[:alert] = @item.errors.inspect
        respond_with(@item, :layout => !request.xhr?) do |format|
          format.js {render :partial => "partials/show_message"}
        end
      else
        respond_with(@item, :layout => !request.xhr?)
      end
  end

end