class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :sku
      t.string :item
      t.string :color
      t.string :size
      t.integer :cod
      t.integer :stock

      t.timestamps
    end
  end
end
