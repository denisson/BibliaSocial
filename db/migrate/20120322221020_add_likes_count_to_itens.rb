class AddLikesCountToItens < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
       t.integer :likes_count, :null => false, :default => 0
       t.integer :dislikes_count, :null => false, :default => 0
       t.integer :saldo_votos, :null => false, :default => 0
    end
    change_table :links do |t|
       t.integer :likes_count, :null => false, :default => 0
       t.integer :dislikes_count, :null => false, :default => 0
       t.integer :saldo_votos, :null => false, :default => 0
    end
    change_table :videos do |t|
       t.integer :likes_count, :null => false, :default => 0
       t.integer :dislikes_count, :null => false, :default => 0
       t.integer :saldo_votos, :null => false, :default => 0
    end
    change_table :referencias do |t|
       t.integer :likes_count, :null => false, :default => 0
       t.integer :dislikes_count, :null => false, :default => 0
       t.integer :saldo_votos, :null => false, :default => 0
    end
    change_table :atividades do |t|
       t.integer :likes_count, :null => false, :default => 0
       t.integer :dislikes_count, :null => false, :default => 0
       t.integer :saldo_votos, :null => false, :default => 0
    end

    Comment.all.each do |item|
      item.update_attributes!(:likes_count => item.likes.count)
      item.update_attributes!(:dislikes_count => item.dislikes.count)
      item.update_attributes!(:saldo_votos => item.likes.count - item.dislikes.count)
    end
    Link.all.each do |item|
      item.update_attributes!(:likes_count => item.likes.count)
      item.update_attributes!(:dislikes_count => item.dislikes.count)
      item.update_attributes!(:saldo_votos => item.likes.count - item.dislikes.count)
    end
    Video.all.each do |item|
      item.update_attributes!(:likes_count => item.likes.count)
      item.update_attributes!(:dislikes_count => item.dislikes.count)
      item.update_attributes!(:saldo_votos => item.likes.count - item.dislikes.count)
    end
    Referencia.all.each do |item|
      item.update_attributes!(:likes_count => item.likes.count)
      item.update_attributes!(:dislikes_count => item.dislikes.count)
      item.update_attributes!(:saldo_votos => item.likes.count - item.dislikes.count)
    end

  end

  def self.down
    remove_column :comments, :likes_count
    remove_column :comments, :dislikes_count
    remove_column :comments, :saldo_votos
    remove_column :links, :likes_count
    remove_column :links, :dislikes_count
    remove_column :links, :saldo_votos
    remove_column :videos, :likes_count
    remove_column :videos, :dislikes_count
    remove_column :videos, :saldo_votos
    remove_column :referencias, :likes_count
    remove_column :referencias, :dislikes_count
    remove_column :referencias, :saldo_votos
    remove_column :atividades, :likes_count
    remove_column :atividades, :dislikes_count
    remove_column :atividades, :saldo_votos
  end
end
