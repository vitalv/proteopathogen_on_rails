class SpectraAcquisitionRun < ActiveRecord::Base
  # attr_accessible :title, :body
  has_and_belongs_to_many :spectrum_identifications, :join_table => :sar_si_join_table, :uniq => true
  before_destroy { |sar| sar.spectrum_identifications.clear }
  validates :spectra_file, :uniqueness => true
  belongs_to :mzid_file
  validates :mzid_file_id, :presence => true
  validates :fraction, :presence => true
end
