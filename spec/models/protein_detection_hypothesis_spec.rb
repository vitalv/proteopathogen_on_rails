require 'spec_helper'

describe "An instance of", ProteinDetectionHypothesis do

  before "built with factory girl" do 
    @pdh = build(:protein_detection_hypothesis)
  end

  it "should be properly initialized" do  
    @pdh.should be_a(ProteinDetectionHypothesis)
  end
 
  it "should be valid  on FactoryGirl build" do
    @pdh.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:protein_detection_hypothesis).should be_valid
  end
  
  it "should be invalid without protein_detection_hypothesis_id" do
    @pdh.protein_detection_hypothesis_id = nil
    @pdh.should_not be_valid
  end
  
  it "should be invalid without threshold" do
    @pdh.pass_threshold = nil
    @pdh.should_not be_valid
  end

  it "should be invalid without pag_id" do
    @pdh.protein_ambiguity_group_id = nil
    @pdh.should_not be_valid
  end

  it "should have many peptide_hypotheses" do
    @pdh.should have_many(:peptide_hypotheses)
  end
  
  it "should belong to PAG" do 
    @pdh.should belong_to(:protein_ambiguity_group)
  end

end





