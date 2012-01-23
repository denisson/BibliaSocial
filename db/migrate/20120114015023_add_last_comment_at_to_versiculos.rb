class AddLastCommentAtToVersiculos < ActiveRecord::Migration
  def self.up
    add_column :versiculos, :last_comment_at, :datetime
  end

  def self.down
    remove_column :versiculos, :last_comment_at
  end
end
