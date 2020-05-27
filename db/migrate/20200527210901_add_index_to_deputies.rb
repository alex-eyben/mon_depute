class AddIndexToDeputies < ActiveRecord::Migration[6.0]
  def change
    add_column :deputies, :uid, :string
    add_index :deputies, :uid, unique: true
  end
end
