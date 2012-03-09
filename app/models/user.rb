class User < ActiveRecord::Base

  
  has_many :atividades
  has_many :comments
  has_many :videos
  has_many :links
  has_many :referencias
  acts_as_followable
  acts_as_follower
  #has_many :users_seguindo, :through => :seguidores
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:confirmable, 
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :facebook_id, :nome, :foto, :email, :password, :password_confirmation, :remember_me
  
  has_attached_file :foto, :styles => {:small => "32x32#", :thumb => "50x50#", :normal => "100x100#"}

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
      user
    else # Create a user with a stub password.
      user = User.create!(:facebook_id => hash_dados.uid, :nome => info.name ,:foto => open(facebook_image(hash_dados.uid)) , :email => info.email, :password => Devise.friendly_token[0,20])
      user.migrar_comentarios
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
end
