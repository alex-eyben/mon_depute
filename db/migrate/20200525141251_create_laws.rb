class CreateLaws < ActiveRecord::Migration[6.0]
  def change
    create_table :laws do |t|
      t.string :title
      t.text :content
      t.string :ressource_link
      t.string :current_status
      t.date :last_status_update
      t.date :start_date

      t.timestamps
    end
  end
end
