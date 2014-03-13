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
  has_many :spectrum_identification_items, through: :spectrum_identification_results
  has_many :peptide_spectrum_assignments, through: :spectrum_identification_items
  
  has_many :spectra_acquisition_runs
  
  
  
  def read_spectra_data_from_mzid
    mzidf = MzidFile.find(self.mzid_file_id)
    mzid = Nokogiri::XML(File.open(mzidf.location))
    si_id = self.si_id
    spectra_data_refs = []
    mzid_si = mzid.xpath("//xmlns:SpectrumIdentification[@id='#{si_id}']")
    mzid_si.xpath(".//xmlns:InputSpectra").collect do |is| 
      spectra_data_refs << is.attr("spectraData_ref").to_s 
    end
    input_spectra = []
    spectra_data_refs.each do |s|
      input_spectra << mzid.xpath("//xmlns:SpectraData[@id='#{s}']").attr("location").to_s.split(/[\/|\\]/)[-1]
    end
    return input_spectra
  end
  
  
  def sar_input_spectra_files
    return self.spectra_acquisition_runs.collect { |sar| sar.spectra_file }  
  end
  
  
  def decoy_psms

   #has_many_psms through above, enables to do self.peptide_spectrum_assignments here:
    decoy_psms = []
    self.peptide_spectrum_assignments.each do |psm|
      if psm.peptide_evidence.db_sequence.accession =~ /decoy/i  or psm.peptide_evidence.is_decoy == true
        decoy_psms << psm 
      end
    end
    return decoy_psms.count
    
    #otherwise, I would have to fetch first sirs, then psms, which is way longer
    #sirs = self.spectrum_identification_results
    #sir_siis_sets = {}
    #sirs.each { |sir| sir_siis_sets[sir] = sir.spectrum_identification_items }
    #sii_psms_sets = {} #k es el sii, v es la lista de psms
    #sir_siis_sets.each do |sir, sii_set|
       #sii_set.each { |sii| sii_psms_sets[sii] = sii.peptide_spectrum_assignments } 
    #end
    #psms_sets = sii_psms_sets.values
    #decoy_psms = []
    #psms_sets.each do |psm_set|
      #psm_set.each do |psm|
        #if psm.peptide_evidence.db_sequence.accession =~ /decoy/i  or psm.peptide_evidence.is_decoy == true
          #decoy_psms << psm 
        #end
      #end
    #end
    #return decoy_psms.count
    
    
  end
  
  
  
  
end




