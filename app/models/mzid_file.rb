class MzidFile < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :location, presence: true
  validates :sha1, uniqueness: true
  validates :name, presence: true
  validates :experiment_id, presence: true
  belongs_to :experiment
  has_many :spectrum_identifications, :dependent => :destroy
  #validates_associated :spectrum_identifications  #This is in the other part of the association
   
  
  def self.spectra_files  
    @mzidf_input_spectra_files = {} #HASH: {4=>["AtiO2.mzML", "Elu1A.mzML", "Elu2A.mzML"], 5=>["MYOGLOBIN_ECD.mgf"]} 
    self.all.each do |mzidf|
      input_spect_files = []  
      spectra_data = Nokogiri::XML(File.open(mzidf.location)).xpath("//xmlns:SpectraData")
      spectra_data.each do |s| #<SpectraData> minOccurs = 1
        input_spect_files << s.attr("location").split("/")[-1] #attr location required
      end
      @mzidf_input_spectra_files[mzidf.id] = input_spect_files
    end    
    return @mzidf_input_spectra_files
  end
  
  
  #def si_sars
    #self.id
    #mzid = Nokogiri::XML(File.open(self.location))
    #mzid_si = mzid.xpath("//xmlns:SpectrumIdentification")
    #my_sis = SpectrumIdentification.where(si_id: mzid_si.attr("id"), mzid_file_id: self.id)
    #si.xpath(".//xmlns:InputSpectra").each do |is|
      #spectraData_ref = is.attr("spectraData_ref")
      #mzid.xpath("//xmlns:SpectraData[@id='#{spectraData_ref}']")
    #end
  #end
  
  
  def includes_protein_detection 
    pd = false
    self.spectrum_identifications.each do |si|
      pd = true if si.spectrum_identification_list.protein_detection
    end
    return pd
  end
  
  def protein_detection
    if self.includes_protein_detection
      pds = self.spectrum_identifications.collect { |si| si.spectrum_identification_list.protein_detection}
      return pds.compact.uniq[0] if pds.compact.uniq.length == 1 
    end  
  end
  
  
  
end
