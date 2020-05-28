class AddImgToDeputies < ActiveRecord::Migration[6.0]
  def change
    add_column :deputies, :img, :string
  end
end
