require "open-uri"
require "acts_as_item"

class Link < ActiveRecord::Base
  include ActsAsItem
  acts_as_item

	# n�o deu certo pq salva primeiro o link, ent�o n�o tem comment_id ainda!
	#validates :url,:presence => true, :uniqueness => {:scope => [:user_id, :versiculo_id, :comment_id]}
	
	def self.criar(link_hash)
    objeto =  construir(link_hash)
    if objeto != nil
      objeto.save
    else
      objeto = Link.new
      objeto.errors.add("link", "Link Invalido")
    end
    return objeto
	end
	
	def self.criar_com_comment(link_hash, texto)
		link = criar(link_hash)
		if link.errors.empty?
		  comment = Comment.criar({:user => link_hash[:user], :versiculo => link_hash[:versiculo], :texto => texto, :item => link})
    end
		return link
  end

  def self.construir(link_hash)
    return nil if !pode_ser? link_hash[:url]
		meta_info = get_meta_info(adicionar_protocolo(link_hash[:url]))
		if meta_info != nil
			meta_info[:user] = link_hash[:user]
			meta_info[:versiculo] = link_hash[:versiculo]
			meta_info[:comment] = link_hash[:comment]
			if meta_info[:type] == "Video"
				return Video.new(meta_info)
			else
				return Link.new(meta_info)
			end
		else
			return nil
		end
  end
	
	def self.get_meta_info(url)
		begin
			#tenta abrir um link especificado
			page = Nokogiri::HTML(open(url))
    rescue Exception => e
			return {:type => "Link", :url => url, :titulo => nome_site(url)}
	  end

		video_link = page.css('meta[property="og:video"]').first
		if video_link != nil
			thumb_url = page.css('meta[property="og:image"]').first.attribute('content').content
			titulo = page.css('meta[property="og:title"]').first.attribute('content').content
			player_url = video_link.attribute('content').content

			return {:type => "Video",
					:thumb_url => thumb_url,
					:link_url => url,
					:player_url => player_url,
					:titulo => titulo}

		else
			titulo_meta_tag = page.css('meta[property="og:title"]').first
			if titulo_meta_tag != nil
				titulo = titulo_meta_tag.attribute('content').content
			else
				titulo_tag = page.css('title').first
				titulo = titulo_tag.content if titulo_tag != nil
			end

			return {:type => "Link", :url => url, :titulo => titulo} if titulo != nil
		end
		return nil
	end

	def descricao_atividade
		"adicionou um link"
	end

	def descricao_atividade_conectivo
		"em"
	end
	
	def self.pode_ser?(string)
		return string =~ regex
	end
	
	def self.regex
		/(https?:\/\/)?((([\da-z-]+)\.)+([a-z]{2,6}))(\:\d+)?(\/[\w\?=#&$!\*\"\'\(\)\,\;\:\%\+\.-]*)*/
	end
	
	def self.nome_site(url)
		if url =~ regex
			return $2
		else
			return url
		end
	end
	
	def self.adicionar_protocolo(url)
		if url =~ regex
			url = "http://" + url if $1 == nil
		end
		return url
	end
	
end
