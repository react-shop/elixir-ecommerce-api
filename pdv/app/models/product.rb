class Product < ApplicationRecord
	has_many_attached :images
  # Note that implicit association has a plural form in this case
  scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }
end
