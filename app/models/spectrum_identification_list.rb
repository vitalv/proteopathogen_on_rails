class SpectrumIdentificationList < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification
  validates :sil_id, uniqueness: {scope: :spectrum_identification_id}, presence: true
  has_many :spectrum_identification_results, dependent: :destroy
  validates_associated :spectrum_identification_results
  belongs_to :protein_detection
  #protein_detection_id can be null !!!
end
