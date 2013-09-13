require 'spec_helper'

describe "An instance of", PeptideHypothesis do

  before "built with factory girl" do 
    @pep_h = build(:peptide_hypothesis)
  end

  it "should be properly initialized" do  
    @pep_h.should be_a(PeptideHypothesis)
  end
 
  it "should be valid  on FactoryGirl build" do
    @pep_h.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:peptide_hypothesis).should be_valid
  end
  
  it "should be invalid without protein_detection_hypothesis_id" do
    @pep_h.protein_detection_hypothesis_id = nil
    @pep_h.should_not be_valid
  end
  
  it "should be invalid without psa_id" do
    @pep_h.peptide_spectrum_assignment = nil
    @pep_h.should_not be_valid
  end

  it "should belong to protein_detection_hypothesis" do 
    @pep_h.should belong_to(:protein_detection_hypothesis)
  end
  
  it "should belong to PeptideSpectrumAssignmt" do 
    @pep_h.should belong_to(:peptide_spectrum_assignment)
  end

end




