class PdhUserParam < ActiveRecord::Base
  belongs_to :protein_detection_hypothesis
  validates :protein_detection_hypothesis_id, presence: true
  validates :name, presence: true   
end
