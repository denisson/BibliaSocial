# encoding: utf-8
class User < ActiveRecord::Base

  
  has_many :atividades, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  has_many :links, :dependent => :destroy
  has_many :referencias, :dependent => :destroy
  #has_many :citacoes
  has_many :votos, :as => :votavel, :dependent => :destroy
  scope :top, order('reputacao desc').order('created_at')

  validates :nome, :presence => true

  acts_as_followable
  acts_as_follower
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable, 
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :facebook_id, :nome, :foto, :email, :password, :password_confirmation, :remember_me, :seguindo_count, :seguidores_count, :atividades_count, :likes_count, :dislikes_count, :reputacao
  
  has_attached_file :foto, :styles => {:small => "32x32#", :thumb => "50x50#", :normal => "100x100#"}
  validates_attachment_content_type :foto, :content_type => /^image.*/ , :message => 'precisa ser um arquivo de imagem (jpeg, jpg, png)'
  before_post_process :image?

  def atualizar_reputacao
    User.where(:id => self.id).update_all("reputacao = atividades_count + seguidores_count + likes_count - dislikes_count")
  end

  def self.find_for_facebook_oauth(hash_dados, signed_in_resource=nil)
    info = hash_dados.info
    if user = User.where(:email => info.email).first
      if user.facebook_id == nil
        user.facebook_id = hash_dados.uid
        user.nome = info.name
        user.foto = open(facebook_image(hash_dados.uid))
        user.save
        user.migrar_comentarios
      end
      return user
    else # Create a user with a stub password.
      user = User.create!(:facebook_id => hash_dados.uid, :nome => info.name ,:foto => open(facebook_image(hash_dados.uid)) , :email => info.email, :password => Devise.friendly_token[0,20])
      user.migrar_comentarios
      return user
    end
  end

  def self.facebook_image(facebook_id)
    "http://graph.facebook.com/"+facebook_id+"/picture?type=normal"
  end

  def migrar_comentarios
    comentarios = MigracaoComentario.find_all_by_facebook_user_id(self.facebook_id);
    comentarios.each do |comentario|
      Comment.criar({:texto => comentario.texto, :user => self, :versiculo_id => comentario.versiculo_id, :created_at => comentario.created_at, :updated_at => comentario.updated_at })
    end

  end

  def tem_facebook?
    facebook_id != nil
  end

  def tem_foto?
    foto.exists?
  end

  def tem_atividades?
    atividades.size > 0
  end

  def segue_alguem?
    seguindo_count > 0
  end

  def seguir(user)
    self.follow(user)
    user.atualizar_reputacao
    begin
      UserMailer.notificar_seguidor_novo(user, self).deliver
    rescue Exception => e
       logger.error e.message
    end
  end

  def deixar_de_seguir(user)
    self.stop_following(user)
    user.atualizar_reputacao
  end

  def nome_curto
    if nome.size < 20
      return nome
    else
      return nome.split(' ').first.truncate(19, :omission => "")
    end
  end

  private
  def image?
    !(foto.content_type =~ /^image.*/).nil?
  end
end
