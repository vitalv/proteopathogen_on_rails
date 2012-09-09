class SpectrumIdentificationItem < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sii_id, :presence => true
  belongs_to :spectrum_identification_result
end
