class AddVotantToPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :positions, :votant, :boolean
  end
end
