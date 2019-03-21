class AddSpotlightToProduct < ActiveRecord::Migration[5.2]
  def change
  	add_column :products, :spotlight, :boolean
  end
end
