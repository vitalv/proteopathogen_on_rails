class PeptideEvidence < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :peptide_id, :presence => true
  belongs_to :peptide
  has_and_belongs_to_many :spectrum_identification_items, :join_table => 'sii_pepevidence_join_table'
  has_and_belongs_to_many :protein_detection_hypothesis, :join_table => 'protein_hypothesis_pepevidence_join_table'
end
