class Modification < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :peptide
end
