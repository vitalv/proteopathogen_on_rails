class SiiPsiMsCvTerm < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_item
end
