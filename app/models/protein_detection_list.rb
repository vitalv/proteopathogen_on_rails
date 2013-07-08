class ProteinDetectionList < ActiveRecord::Base
  belongs_to :protein_detection
  validates_uniqueness_of :pdl_id, :scope => :protein_detection_id
  has_many :protein_ambiguity_groups, :dependent => :destroy
  
end


 
