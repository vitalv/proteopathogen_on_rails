class ProteinDetection < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :protein_detection_id, presence: true
  has_many :spectrum_identification_lists
  has_one :protein_detection_list, dependent: :destroy
  has_one :protein_detection_protocol, dependent: :destroy
  has_many :spectrum_identification_list
end
