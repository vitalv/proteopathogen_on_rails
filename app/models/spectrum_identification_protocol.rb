class SpectrumIdentificationProtocol < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sip_id, :presence => true
  validates :spectra_acquisition_run_id, :presence => true
  #has_many :spectrum_identification_results, :through => :spectrum_identification_lists, :dependent => :destroy
  #has_many :spectrum_identification_items, :through => :spectrum_identification_results #nested or multiple has_many :through associations so I can use sip.items
  #validates_associated :spectrum_identification_lists
  has_and_belongs_to_many :search_databases, :join_table => 'sip_sdb_join_table'
  has_and_belongs_to_many :searched_modifications, :join_table => 'sip_searched_mod_join_table'
  has_many :sip_psi_ms_cv_terms, :dependent => :destroy
  has_many :sip_user_params, :dependent => :destroy
  belongs_to :spectra_acquisition_run
end
