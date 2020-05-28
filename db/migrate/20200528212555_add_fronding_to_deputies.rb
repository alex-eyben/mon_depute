class AddFrondingToDeputies < ActiveRecord::Migration[6.0]
  def change
    add_column :deputies, :fronding, :integer
  end
end
