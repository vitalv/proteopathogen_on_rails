class SpectraAcquisitionRun < ActiveRecord::Base
  # attr_accessible :title, :body
  has_and_belongs_to_many :spectrum_identifications, :join_table => :sar_si_join_table, , :uniq => true
  validates :spectra_file, :uniqueness => true
  belongs_to :mzid_file
end
