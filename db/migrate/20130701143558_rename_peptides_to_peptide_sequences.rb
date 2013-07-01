class RenamePeptidesToPeptideSequences < ActiveRecord::Migration
  def up
    rename_table :peptides, :peptide_sequences
  end

  def down
    rename_table :peptides_sequences, :peptides
  end
end
