class AddColumnsToPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :positions, :date, :date
    add_column :positions, :maj_position, :string
    add_column :positions, :vote_position_cause, :string
    add_column :positions, :deputy_group_position, :string
  end
end
