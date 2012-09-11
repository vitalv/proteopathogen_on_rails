class SpectrumIdentificationProtocol < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sip_id, :presence => true
  has_many :spectrum_identification_lists, :dependent => :destroy
  validates_associated :spectrum_identification_lists
  has_many :searched_modifications, :dependent => :destroy
  has_many :sip_psi_ms_cv_terms, :dependent => :destroy
  has_many :sip_user_params, :dependent => :destroy
end
