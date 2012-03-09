require "acts_as_item"

class Video < ActiveRecord::Base
  include ActsAsItem
  acts_as_item

  def self.criar(video_hash)
    objeto = Link.construir(video_hash)
    if objeto != nil and objeto.is_a? Video
      objeto.save
    else
      objeto =  Video.new
      objeto.errors.add("video", "Video inválido!")
    end
    return objeto
  end

  def self.criar_com_comment(video_hash, texto)
    video = criar(video_hash)
    if video.errors.empty?
      comment = Comment.criar({:user => video_hash[:user], :versiculo => video_hash[:versiculo], :texto => texto, :item => video})
    end
    return video
  end


	def descricao_atividade
		"adicionou um vídeo"
	end
	
	def descricao_atividade_conectivo
		"em"
	end
end
