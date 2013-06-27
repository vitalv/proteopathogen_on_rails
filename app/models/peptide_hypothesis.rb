class PeptideHypothesis < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :peptide_evidence
  belongs_to :spectrum_identification_item
  belongs_to :protein_hypohtesis
end
