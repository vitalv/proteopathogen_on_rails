class SpectrumIdentification < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :si_id, :presence => true
  
  has_and_belongs_to_many :spectra_acquisition_runs, :join_table => :sar_si_join_table, :uniq => true
  before_destroy { |si| si.spectra_acquisition_runs.clear } #avoids orphans in join table
  
  has_and_belongs_to_many :search_databases, :join_table => :sdb_si_join_table, :uniq => true
  before_destroy { |si| si.search_databases.clear } #avoids orphans in join table
  
  has_one :spectrum_identification_protocol, :dependent => :destroy
  validates_associated :spectrum_identification_protocol
  
  has_one :spectrum_identification_list, :dependent => :destroy
  validates_associated :spectrum_identification_list
  
  has_many :spectrum_identification_results, :through => :spectrum_identification_list, :dependent => :destroy
  
  
  
end
