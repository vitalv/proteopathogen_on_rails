class CreateSiiPeptideEvidences < ActiveRecord::Migration
  def change
    create_table :sii_peptide_evidences do |t|
      t.references :spectrum_identification_item
      t.references :peptide_evidence
    end
  end
end
