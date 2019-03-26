class ProductImage < ApplicationRecord
  belongs_to :product_id
  belongs_to :image_id
end
