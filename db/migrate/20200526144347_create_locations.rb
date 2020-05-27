class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :department
      t.string :commune
      t.string :circonscription

      t.timestamps
    end
  end
end
