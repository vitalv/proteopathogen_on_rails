class ProteinDetectionProtocol < ActiveRecord::Base
  belongs_to :protein_detection
  validates_uniqueness_of :pdp_id, :scope => :protein_detection_id
  # attr_accessible :title, :body
end
