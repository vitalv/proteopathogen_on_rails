class SpectrumIdentificationResult < ActiveRecord::Base
  # attr_accessible :title, :body
    validates :sir_id, presence: true
    validates :spectrum_identification_list_id,  presence: true
    belongs_to :spectrum_identification_list
    has_many :spectrum_identification_items, dependent: :destroy
    validates_associated :spectrum_identification_items
    has_many :sir_psi_ms_cv_terms, dependent: :destroy
    has_many :sir_user_params, dependent: :destroy
    #validates_uniqueness_of :sir_id, :scope => :spectrum_identification_list_id #rails3.2
    validates :sir_id, uniqueness: {scope: :spectrum_identification_list_id}, presence: true #rails4

  def spectrum_title
    title = ""
    self.sir_psi_ms_cv_terms.map { |cvp| title = cvp.value if cvp.psi_ms_cv_term == "MS:1000796"}
    return title unless title.blank?
  end

end
