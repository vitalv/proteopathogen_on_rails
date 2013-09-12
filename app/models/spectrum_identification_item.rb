class SpectrumIdentificationItem < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sii_id, uniqueness: {scope: :spectrum_identification_result_id}, presence: true
  validates :spectrum_identification_result_id, presence: true
  validates :charge_state, presence: true
  validates :exp_m2z, presence: true
  belongs_to :spectrum_identification_result
  has_many :sii_psi_ms_cv_terms, dependent: :destroy
  has_many :sii_user_params, dependent: :destroy
  has_many :fragments, dependent: :destroy  
  has_many :peptide_spectrum_assignments, dependent: :destroy
  has_many :peptide_hypotheses, through: :peptide_spectrum_assignments
  has_many :peptide_evidences, through: :peptide_spectrum_assignments#, dependent: :destroy
end
