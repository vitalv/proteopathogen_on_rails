class SpectrumIdentificationList < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_protocol
  validates :spectrum_identification_protocol_id, :presence => true
end
