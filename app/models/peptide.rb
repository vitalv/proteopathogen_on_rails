class Peptide < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :spectrum_identification_items
  has_many :peptide_evidences
end
