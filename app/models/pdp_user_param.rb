class PdpUserParam < ActiveRecord::Base
  belongs_to :protein_detection_protocol
  validates :protein_detection_protocol_id, presence: true
  validates :name, presence: true 
end
