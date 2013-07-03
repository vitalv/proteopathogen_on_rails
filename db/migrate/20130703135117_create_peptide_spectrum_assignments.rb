class CreatePeptideSpectrumAssignments < ActiveRecord::Migration
  def change
    create_table :peptide_spectrum_assignments do |t|
      t.references :spectrum_identification_item
      t.references :peptide_evidence
    end
  end
end


