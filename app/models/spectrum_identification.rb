class SpectrumIdentification < ActiveRecord::Base
  # attr_accessible :title, :body

  validates :si_id, uniqueness: {scope: :mzid_file_id}, presence: true
  
  belongs_to :mzid_files
  validates :mzid_file_id, presence: true
  
  has_and_belongs_to_many :search_databases,  join_table: "sdb_si_join_table"
  before_destroy { |si| si.search_databases.clear } #avoids orphans in join table
  
  has_one :spectrum_identification_protocol, dependent: :destroy
  validates_associated :spectrum_identification_protocol #<SpectrumIdentification spectrumIdentificationProtocol_ref: required > 
  
  has_one :spectrum_identification_list, dependent: :destroy
  validates_associated :spectrum_identification_list  #<SpectrumIdentification spectrumIdentificationList_ref: required > 
  
  has_many :spectrum_identification_results, through: :spectrum_identification_list #, :dependent => :destroy
  
end
