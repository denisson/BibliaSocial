class Link < ActiveRecord::Base
	belongs_to :user
	belongs_to :versiculo, :counter_cache => true
	belongs_to :comment
	
	has_one :atividade, :as => :item, :dependent => :destroy

	# não deu certo pq salva primeiro o link, então não tem comment_id ainda!
	#validates :url,:presence => true, :uniqueness => {:scope => [:user_id, :versiculo_id, :comment_id]}
	
	default_scope order("created_at DESC")
	scope :where_versiculo , lambda { |versiculo| where(:versiculo_id => versiculo)}
	
	after_create :criar_atividade
	
	def criar_atividade
		if self.comment == nil
			@atividades = self.versiculo.atividades.create({:user => self.user, :item => self})
		end
	end
	
	def self.criar(link_hash)
		meta_info = get_meta_info(link_hash[:url])
		if meta_info != nil
			meta_info[:user] = link_hash[:user]
			meta_info[:versiculo] = link_hash[:versiculo]
			meta_info[:comment] = link_hash[:comment]
			if meta_info[:type] == "Video"
				return Video.create(meta_info)
			else
				return Link.create(meta_info)
			end
		else
			return nil
		end
	end
	
	def self.criar_com_comment(link_hash, texto)
		link = criar(link_hash)
		return nil if link == nil
		comment = Comment.criar({:user => link_hash[:user], :versiculo => link_hash[:versiculo], :texto => texto, :item => link})
		link.comment = comment
		link.save
		return link
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
