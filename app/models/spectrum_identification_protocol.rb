class SpectrumIdentificationProtocol < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sip_id, :presence => true
  has_and_belongs_to_many :searched_modifications, :join_table => 'sip_searched_mod_join_table'
  has_many :sip_psi_ms_cv_terms, :dependent => :destroy
  has_many :sip_user_params, :dependent => :destroy
  belongs_to :spectrum_identification
end
