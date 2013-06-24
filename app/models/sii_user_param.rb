class SiiUserParam < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_item, :dependent => :destroy
  validates :spectrum_identification_item_id, :presence => true
end
