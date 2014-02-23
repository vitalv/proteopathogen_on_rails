class SpectraAcquisitionRun < ActiveRecord::Base
  belongs_to :spectrum_identification
  validates :spectrum_identification_id, presence: true
  #validates :spectra_file, :uniqueness => true
  validates :fraction, presence: true


end
