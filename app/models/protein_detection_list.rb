class ProteinDetectionList < ActiveRecord::Base
  belongs_to :protein_detection
  validates :pdl_id, uniqueness: {scope: :protein_detection_id}, presence: true
  has_many :protein_ambiguity_groups, dependent: :destroy  
end


 
