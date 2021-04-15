class AddSlugToDeputies < ActiveRecord::Migration[6.0]
  def change
    add_column :deputies, :slug, :string
    add_index :deputies, :slug, unique: true
  end
end
