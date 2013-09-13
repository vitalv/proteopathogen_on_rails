class ProteinDetectionProtocol < ActiveRecord::Base
  belongs_to :protein_detection
  validates :pdp_id, uniqueness: {scope: :protein_detection_id}, presence: true
  validates :analysis_software, presence: true
  validates :protein_detection_id, presence: true
  has_many :pdp_psi_ms_cv_terms, dependent: :destroy
  has_many :pdp_user_params, dependent: :destroy
end
