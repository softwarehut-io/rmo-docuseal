class AddIsPublicToTemplateFolder < ActiveRecord::Migration[7.1]
  def change
    add_column :template_folders, :is_public, :boolean, :default => false
  end
end
