class SpectrumIdentificationResult < ActiveRecord::Base
  # attr_accessible :title, :body
    validates :sir_id, :presence => true
    belongs_to :spectrum_identification_list
    has_many :spectrum_identification_items, :dependent => destroy
    validates_associated :spectrum_identification_items
end
