class SpectrumIdentificationResult < ActiveRecord::Base
  # attr_accessible :title, :body
    validates :sir_id, :presence => true
    belongs_to :spectrum_identification_list
end
