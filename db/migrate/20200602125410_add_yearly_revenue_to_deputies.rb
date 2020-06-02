class AddYearlyRevenueToDeputies < ActiveRecord::Migration[6.0]
  def change
    add_column :deputies, :yearly_revenue, :integer
  end
end
