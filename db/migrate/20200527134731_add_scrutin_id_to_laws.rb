class AddScrutinIdToLaws < ActiveRecord::Migration[6.0]
  def change
    add_column :laws, :scrutin_id, :integer
  end
end
