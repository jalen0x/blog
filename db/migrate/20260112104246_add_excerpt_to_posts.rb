class AddExcerptToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :excerpt, :text
  end
end
