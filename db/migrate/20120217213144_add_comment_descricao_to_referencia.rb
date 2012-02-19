class AddCommentDescricaoToReferencia < ActiveRecord::Migration
  def self.up
    change_table :referencias do |t|
      t.belongs_to :comment_descricao
    end
  end

  def self.down
    remove_column :referencias, :comment_descricao
  end
end
