class Link < ActiveRecord::Base
	belongs_to :user
	belongs_to :versiculo, :counter_cache => true
	belongs_to :comment
	
	has_one :atividade, :as => :item, :dependent => :destroy
	has_one :comment_item, :as => :item
	
	validates :url,:presence => true, :uniqueness => {:scope => [:user_id, :versiculo_id]}
	
	default_scope order("created_at DESC")
	
	after_create :criar_atividade
	
	def criar_atividade
		if self.comment == nil
			self.versiculo.atividades.create({:user => self.user, :item => self})
		end
	end
	
	def self.create_link_completo(user, versiculo, url, comment)
		meta_info = get_meta_info(url)
		if meta_info != nil
			meta_info[:user] = user
			meta_info[:versiculo] = versiculo
			if meta_info[:type] == "Video"
				if comment != nil
					return comment.videos.create(meta_info)
				else
					return versiculo.videos.create(meta_info)
				end
			else
				if comment != nil
					return comment.links.create(meta_info)
				else
					return versiculo.links.create(meta_info)
				end
			end
		end
	end
	
	def self.create_link_comment(comment, url)
		create_link_completo comment.user, comment.versiculo, url, comment
	end
	
	def self.create_link(user, versiculo, url)
		create_link_completo(user, versiculo, url, nil)
	end
	
	def self.get_meta_info(url)
		begin
			#tenta abrir um link especificado
			page = Nokogiri::HTML(open(url))
		rescue
			#caso não consiga, não salva nada
			return nil
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
	
end
