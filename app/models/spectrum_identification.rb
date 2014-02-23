class SpectrumIdentification < ActiveRecord::Base

  validates :si_id, uniqueness: {scope: :mzid_file_id}, presence: true
  
  belongs_to :mzid_file
  validates :mzid_file_id, presence: true
  validates :mzid_file, presence: true
  validates_associated :mzid_file
  
  has_and_belongs_to_many :search_databases,  join_table: "sdb_si_join_table"
  before_destroy { |si| si.search_databases.clear } #avoids orphans in join table
  
  has_one :spectrum_identification_protocol, dependent: :destroy   
  #comprobar si esto hace algo!?:
  #validates_associated :spectrum_identification_protocol #<SpectrumIdentification spectrumIdentificationProtocol_ref: required > 
  #no, no hace nada a menos que valide su presencia antes
   
  has_one :spectrum_identification_list, dependent: :destroy
  #validates_associated :spectrum_identification_list  #<SpectrumIdentification spectrumIdentificationList_ref: required > 
  
  #Note: SpectrumIdentificationProtocol and SpectrumIdentificationList are both required attributes in element <SpectrumIdentification> which MUST be (and always is) present in the mzid file
  #so I am not validating them here. 
   
  has_many :spectrum_identification_results, through: :spectrum_identification_list #, :dependent => :destroy
  
  has_many :spectra_acquisition_runs
  
  
  
  def read_spectra_data_from_mzid
    mzidf = MzidFile.find(self.mzid_file_id)
    mzid = Nokogiri::XML(File.open(mzidf.location))
    si_id = self.si_id
    spectra_data_refs = []
    mzid.xpath("//xmlns:SpectrumIdentification[@id='#{si_id}']").xpath(".//xmlns:InputSpectra").collect { |is| spectra_data_refs << is.attr("spectraData_ref").to_s }
    input_spectra = []
    spectra_data_refs.each do |s|
      input_spectra << mzid.xpath("//xmlns:SpectraData[@id='#{s}']").attr("location").to_s.split(/[\/|\\]/)[-1]
    end
    return input_spectra
  end
  
  
  def sar_input_spectra_files
    return self.spectra_acquisition_runs.collect { |sar| sar.spectra_file }  
  end
  
  
end
