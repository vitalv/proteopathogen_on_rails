class ProteinAmbiguityGroup < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :protein_detection_hypotheses, dependent: :destroy
  belongs_to :protein_detection_list
  validates :protein_ambiguity_group_id, uniqueness: {scope: :protein_detection_list_id}, presence: true
  validates :protein_detection_list_id, presence: true
  
  def accessions_in_group
    return self.protein_detection_hypotheses.map { |pdh| pdh.protein_detection_hypothesis_id}.join(", ")
  end
  
end
