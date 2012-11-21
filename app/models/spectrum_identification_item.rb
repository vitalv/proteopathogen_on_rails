class SpectrumIdentificationItem < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sii_id, :presence => true
  validates :spectrum_identification_result_id, :presence => true
  belongs_to :spectrum_identification_result
  has_many :sii_psi_ms_cv_terms, :dependent => :destroy
  has_many :fragments, :dependent => :destroy
  belongs_to :peptide
  has_and_belongs_to_many :peptide_evidences, :join_table => 'sii_pepevidence_join_table'
end
