class AddPositionsToLaws < ActiveRecord::Migration[6.0]
  def change
    add_column :laws, :pour, :integer
    add_column :laws, :contre, :integer
    add_column :laws, :abstenu, :integer
  end
end
