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
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_attached_file :foto, :styles => {:small => "32x32#", :thumb => "50x50#", :normal => "100x100#"}
end
