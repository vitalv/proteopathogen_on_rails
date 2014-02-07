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
    #get this from existing mzidfile.spectra_acquisition_runs
    #~ spect_acq_runs, @stored_spectra_files = [], []  
    self.all.each do |mzidf|
      #get this from the mzid file
      input_spect_files = []  
      #~ if File.exists? mzidf.location
        #~ spect_acq_runs = MzidFile.find(mzidf).spectra_acquisition_runs
        #~ unless spect_acq_runs.blank?
          #~ spect_acq_runs.each do |sar|
            #~ @stored_spectra_files << sar.spectra_file
          #~ end
        #~ end
      #~ end
      spectra_data = Nokogiri::XML(File.open(mzidf.location)).xpath("//xmlns:SpectraData")
      spectra_data.each do |s| #<SpectraData> minOccurs = 1
        input_spect_files << s.attr("location").split("/")[-1] #attr location required
      end
      @mzidf_input_spectra_files[mzidf.id] = input_spect_files
    end    
    return @mzidf_input_spectra_files
  end
  
  
  
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
