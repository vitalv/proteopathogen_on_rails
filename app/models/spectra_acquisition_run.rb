class SpectraAcquisitionRun < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :spectrum_identification_protocols, :dependent => :destroy
  validates :spectra_file, :uniqueness => true
  belongs_to :mzid_file
end
