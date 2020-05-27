class AddDepartmentToDeputys < ActiveRecord::Migration[6.0]
  def change
    add_column :deputys, :department, :integer
  end
end
