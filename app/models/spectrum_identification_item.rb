class SpectrumIdentificationItem < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sii_id, :presence => true
  belongs_to :spectrum_identification_result
  has_many :peptide_evidences, :dependent => destroy
  validates_associated :peptide_evidences
end
