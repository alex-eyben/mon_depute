class AddDepartmentToDeputies < ActiveRecord::Migration[6.0]
  def change
    add_column :deputies, :department, :integer
  end
end
