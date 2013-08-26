require 'test_helper'

class ModificationTest < ActiveSupport::TestCase
  test "should not save without peptide id" do
    mod = Modification.new
    assert !mod.save, "Saved the modification withut peptide_id"
  end
  test "the truth" do 
    assert true
  end
  test "only onte modification at a location for a pep_seq_id and pep_ev_id" do
    mod1 = Modification.create(:location => "1", :unimod_accession => "UNIMOD:21", :peptide_evidence_id => 1, :peptide_sequence_id => 1)
    mod2 = Modification.new(:location => "1", :unimod_accession => "UNIMOD:210", :peptide_evidence_id => 1, :peptide_sequence_id => 1)
    assert !mod2.save, "Saving two modifications at one location of the same peptide? WTF?"
    
  end
end
