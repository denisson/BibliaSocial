module ActsAsItem

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def label
        name
      end

      def descricao_atividade_email
        " do seu " + label.downcase
      end

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

        scope :recentes, order("created_at DESC")
        scope :top, order("saldo_votos DESC").order("created_at DESC")
        scope :top_do_capitulo,  lambda { |capitulo_id| joins(:versiculo).where("versiculos.capitulo_id" => capitulo_id).top}


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

      def atualizar_saldo_votos
        self.update_attributes!(:saldo_votos => "(likes_count - dislikes_count)")
      end

    end

    module NoCommentInstanceMethods
      def criar_atividade
        if self.comment == nil
          Atividade.create({:user => self.user, :item => self, :versiculo => self.versiculo, :created_at => self.created_at, :updated_at => self.updated_at})
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