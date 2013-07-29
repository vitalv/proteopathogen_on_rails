class SpectraAcquisitionRun < ActiveRecord::Base
  belongs_to :spectrum_identification
  validates :spectrum_identification_id, :presence => true
  #before_destroy { |sar| sar.spectrum_identifications.clear }
  validates :spectra_file, :uniqueness => true
  #belongs_to :mzid_file
  #validates :mzid_file_id, :presence => true
  validates :fraction, :presence => true
end
