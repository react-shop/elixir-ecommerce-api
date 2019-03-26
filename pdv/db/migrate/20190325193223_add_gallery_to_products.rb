class AddGalleryToProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :products, :gallery, :string
  end
end
