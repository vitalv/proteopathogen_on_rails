require 'spec_helper'

describe "An instance of", PeptideEvidence do

  before "built with factory girl" do 
    @pev = build(:peptide_evidence)
  end

  it "should be properly initialized" do  
    @pev.should be_a(PeptideEvidence)
  end
 
  it "should be valid  on FactoryGirl build" do
    @pev.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:peptide_evidence).should be_valid
  end
  
  it "should be invalid without pepev_id" do
    @pev.pepev_id = nil
    @pev.should_not be_valid
  end
  
  it "should be invalid without db_sequence_id" do
    @pev.db_sequence_id = nil
    @pev.should_not be_valid
  end

  it "should be invalid without peptide_sequence_id" do
    @pev.peptide_sequence_id = nil
    @pev.should_not be_valid
  end
  
  it "should belong to db_sequence" do 
    @pev.should belong_to(:db_sequence)
  end
  
  it "should belong to db_sequence" do
    @pev.should belong_to(:db_sequence)
  end
 
  it "should have many sii_s through psa_s" do
    @pev.should have_many(:spectrum_identification_items).through(:peptide_spectrum_assignments)
  end

  it "should have many modifications" do 
    @pev.should have_many(:modifications)
  end

end



