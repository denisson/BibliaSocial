class ChangeCommentIdType < ActiveRecord::Migration
  def self.up
	change_table :comentarios do |t|
		t.change :comment_id, :string
	end
  end

  def self.down
	change_table :comentarios do |t|
		t.change :comment_id, :integer
	end
  end
end
