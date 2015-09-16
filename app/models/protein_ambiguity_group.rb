class ProteinAmbiguityGroup < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :protein_detection_hypotheses, dependent: :destroy
  belongs_to :protein_detection_list
  validates :protein_ambiguity_group_id, uniqueness: {scope: :protein_detection_list_id}, presence: true
  validates :protein_detection_list_id, presence: true
  
  def proteins_in_group
    gene_names = []
    pdh_ids = self.protein_detection_hypotheses.map { |pdh| pdh.protein_detection_hypothesis_id}.join(", ")
    self.protein_detection_hypotheses.each do |pdh|
      if pdh.db_seq.description
        if pdh.db_seq.description.split("CGDID:")[0] !~ /^orf/
          gene_names << pdh.db_seq.description.split(" CGDID:")[0]
        end
      end
    end
    gene_names = gene_names.join(", ")
    if !gene_names.empty? 
      proteins = pdh_ids + " (#{gene_names})"
    else 
      proteins = pdh_ids
    end
    return proteins
  end
  
  
  def pdh_ids
    self.protein_detection_hypotheses.map { |pdh| pdh.protein_detection_hypothesis_id}.join(" ; ")
  end
  
  def gene_names
    gene_names = []
    self.protein_detection_hypotheses.each do |pdh|
      if pdh.db_seq and pdh.db_seq.description
        if pdh.db_seq.description.split("CGDID:")[0] !~ /^orf/
          gene_names << pdh.db_seq.description.split(" CGDID:")[0]
        end
      end
    end
    return gene_names.join(" ; ") unless gene_names.empty?
  end
  
end
