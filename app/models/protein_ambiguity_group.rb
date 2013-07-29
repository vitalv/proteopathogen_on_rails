class ProteinAmbiguityGroup < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :protein_detection_hypotheses, dependent: :destroy
  belongs_to :protein_detection_list
end
