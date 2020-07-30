class AddEntryDateToDeputies < ActiveRecord::Migration[6.0]
  def change
    add_column :deputies, :entry_date, :date
  end
end
