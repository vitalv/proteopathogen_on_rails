class SirUserParam < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :spectrum_identification_result
  validates :spectrum_identification_result_id, presence: true
  validates :name, presence: true  
end
