class AddCommentDescricaoToLink < ActiveRecord::Migration
  def self.up
    change_table :links do |t|
      t.belongs_to :comment_descricao
    end
  end

  def self.down
    remove_column :links, :comment_descricao
  end
end
