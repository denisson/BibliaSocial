module ActsAsItem

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_item
        acts_as_item_comment
        include ActsAsItem::NoCommentInstanceMethods

        belongs_to :comment, :counter_cache => true

        has_one :comment_descricao, :as => :item, :class_name => "Comment"

        scope :where_versiculo , lambda { |versiculo| where(:versiculo_id => versiculo)}

        before_destroy :destroy_comment

      end

      def acts_as_item_comment
        include ActsAsItem::InstanceMethods

        belongs_to :user
        belongs_to :versiculo, :counter_cache => true

        has_many :votos, :as => :votavel, :dependent => :delete_all
        has_many :likes, :class_name => 'Voto', :as => :votavel, :conditions => "pontuacao = 1"
        has_many :dislikes, :class_name => 'Voto', :as => :votavel, :conditions => "pontuacao = -1"

        has_one :atividade, :as => :item, :dependent => :destroy

        validates :user_id, :presence => true#, :message => "Você precisa estar logado para fazer esta operação"

        default_scope order("created_at DESC")

        after_create :criar_atividade
      end
    end

    module InstanceMethods

      def voto_user(user)
        if user != nil and (self.likes.size > 0 || self.dislikes.size > 0) #significa que houve algum voto
          voto = self.votos.where(:user_id => user.id).first
        else
          nil
        end
      end

      def votavel
        self
      end

      def independente?
        atividade != nil
      end

      def pode_excluir?(usuario_tenta_excluir)
         usuario_tenta_excluir == user  and independente?
      end

    end

    module NoCommentInstanceMethods
      def criar_atividade
        if self.comment == nil
          Atividade.create({:user => self.user, :item => self, :versiculo => self.versiculo})
        end
      end

      def atividades_dependentes
        if comment_descricao != nil
          comment_descricao.atividades_dependentes
        else
          Array.new
        end
      end

      def destroy_comment
        if comment_descricao != nil
          comment_descricao.destroy
        end
      end

    end

end