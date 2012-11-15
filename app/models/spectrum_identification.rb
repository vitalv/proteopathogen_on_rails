class SpectrumIdentification < ActiveRecord::Base
  # attr_accessible :title, :body
  has_and_belongs_to_many :spectra_acquisition_runs, :join_table => :sar_si_join_table
  has_and_belongs_to_many :search_databases, :join_table => :sdb_si_join_table
  
  has_one :spectrum_identification_protocol
  validates :spectrum_identification_protocol_id, :presence => true
  validates_associated :spectrum_identification_protocol
  
  has_one :spectrum_identification_list
  validates :spectrum_identification_list_id, :presence => true
  validates_associated :spectrum_identification_list
  has_many :spectrum_identification_results, :through => :spectrum_identification_list, :dependent => :destroy
  
  
  
end
