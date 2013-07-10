class ProteinDetectionProtocol < ActiveRecord::Base
  belongs_to :protein_detection
  validates_uniqueness_of :pdp_id, :scope => :protein_detection_id
  has_many :pdp_psi_ms_cv_terms, :dependent => :destroy
  has_many :pdp_user_params, :dependent => :destroy
  # attr_accessible :title, :body
end
