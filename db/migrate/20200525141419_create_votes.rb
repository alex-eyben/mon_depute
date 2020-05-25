class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.string :deputy_position
      t.references :deputy, null: false, foreign_key: true
      t.references :law, null: false, foreign_key: true

      t.timestamps
    end
  end
end
