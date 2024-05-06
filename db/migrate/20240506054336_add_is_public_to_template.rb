class AddIsPublicToTemplate < ActiveRecord::Migration[7.1]
  def change
    add_column :templates, :is_public, :boolean, :default => false
  end
end
