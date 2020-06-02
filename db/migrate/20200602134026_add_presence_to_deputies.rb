class AddPresenceToDeputies < ActiveRecord::Migration[6.0]
  def change
    add_column :deputies, :presence, :integer
  end
end
