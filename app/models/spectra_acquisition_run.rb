class SpectraAcquisitionRun < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identifications
  validates_associated :spectrum_identifications
  before_destroy { |sar| sar.spectrum_identifications.clear }
  validates :spectra_file, :uniqueness => true
  belongs_to :mzid_file
  validates :mzid_file_id, :presence => true
  validates :fraction, :presence => true
end
