class SpectrumIdentificationProtocol < ActiveRecord::Base

  validates :sip_id, presence: true
  validates :search_type, presence: true
 
  has_and_belongs_to_many :searched_modifications, join_table: 'sip_searched_mod_join_table'
  before_destroy { |sip| sip.searched_modifications.clear } #avoids orphans in join table
 
  has_many :sip_psi_ms_cv_terms, dependent: :destroy
 
  has_many :sip_user_params, dependent: :destroy
 
  belongs_to :spectrum_identification  
  validates :spectrum_identification_id, uniqueness: {scope: :sip_id}, presence: true
  
  
  def has_at_least_one_cvp_w_value
    return true unless self.sip_psi_ms_cv_terms.map { |sip| sip.value }.compact.blank?
  end
  
end
