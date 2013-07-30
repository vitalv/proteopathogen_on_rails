class Fragment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_item
  validates :spectrrum_identification_item_id, presence: true
end
