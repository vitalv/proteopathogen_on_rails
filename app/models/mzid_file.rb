class MzidFile < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  before_validation :check_file_extension
  # attr_accessible :title, :body
  validates :location, presence: true
  validates :sha1, uniqueness: true
  validates :name, presence: true
  validates :experiment_id, presence: true
  belongs_to :experiment
  has_many :spectrum_identifications, :dependent => :destroy
  #validates_associated :spectrum_identifications  #This is in the other part of the association
   
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
  
  #private
    def check_file_extension
      if self.name.split(".")[-1] !~ /mzid/i
        errors.add(:name, "- File extension not .mzid")  
      else
        ".mzid file"
      end
    end
    

  def contains_fragmentation_data
    file_rel_path = Pathname.new(self.location).relative_path_from(Rails.root)
    if File.file? file_rel_path.to_s
      mzid = Nokogiri::XML(File.open(file_rel_path.to_s))
      if !mzid.xpath("//xmlns:Fragmentation").blank?
        return true
      else 
        return false
      end
    else 
      return false
    end
  end


  
  
end
