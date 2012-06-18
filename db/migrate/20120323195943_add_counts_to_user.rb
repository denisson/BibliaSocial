class AddCountsToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
       t.integer :seguindo_count, :null => false, :default => 0
       t.integer :seguidores_count, :null => false, :default => 0
       t.integer :atividades_count, :null => false, :default => 0
       t.integer :likes_count, :null => false, :default => 0
       t.integer :dislikes_count, :null => false, :default => 0
       t.integer :reputacao, :null => false, :default => 0
    end
    User.reset_column_information
    User.all.each do |user|
      itens = Array.new
      itens += user.comments
      itens += user.videos
      itens += user.links
      itens += user.referencias
      likes_count = 0
      dislikes_count = 0
      itens.each do |item|
        likes_count += item.likes.count
        dislikes_count += item.dislikes.count
      end

      user.update_attributes!(:seguindo_count =>  user.all_following.count, :seguidores_count =>  user.followers.count, :atividades_count => user.atividades.count, :likes_count => likes_count, :dislikes_count => dislikes_count)
    end
  end

  def self.down
    remove_column :users, :seguindo_count
    remove_column :users, :seguidores_count
    remove_column :users, :atividades_count
    remove_column :users, :likes_count
    remove_column :users, :dislikes_count
  end
end
