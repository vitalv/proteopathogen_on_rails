class SpectrumIdentificationItem < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sii_id, :presence => true
  validates :spectrum_identification_result_id, :presence => true
  belongs_to :spectrum_identification_result, :dependent => :destroy
  has_many :sii_psi_ms_cv_terms, :dependent => :destroy
  has_many :sii_user_params, :dependent => :destroy
  has_many :fragments, :dependent => :destroy  
  has_many :peptide_spectrum_assignments, :dependent => :destroy
  has_many :peptide_evidences, :through => :peptide_spectrum_assignments, :uniq => true 
  validates_uniqueness_of :sii_id, :scope => :spectrum_identification_result_id
end
