class AddMajorityToPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :positions, :majority, :string
  end
end
