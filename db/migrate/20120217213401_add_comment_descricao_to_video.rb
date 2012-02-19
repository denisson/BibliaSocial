class AddCommentDescricaoToVideo < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.belongs_to :comment_descricao
    end
  end

  def self.down
    remove_column :videos, :comment_descricao
  end
end
