class SpectrumIdentificationList < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_protocol
  validates :spectrum_identification_protocol_id, :presence => true
  has_many :spectrum_identification_results, :dependent => destroy
  validates_associated :spectrum_identification_results
end
