class SpectrumIdentificationList < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification
  validates_uniqueness_of :spectrum_identification_id
  has_many :spectrum_identification_results, :dependent => :destroy
  validates_associated :spectrum_identification_results
end
