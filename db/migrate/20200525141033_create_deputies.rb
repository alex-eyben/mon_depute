class CreateDeputies < ActiveRecord::Migration[6.0]
  def change
    create_table :deputies do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :job
      t.string :birth_place
      t.date :birth_date
      t.string :party
      t.string :twitter
      t.string :facebook
      t.string :website
      t.string :revenue
      t.integer :circonscription

      t.timestamps
    end
  end
end
