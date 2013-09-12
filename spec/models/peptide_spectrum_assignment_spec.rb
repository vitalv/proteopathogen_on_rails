
require 'spec_helper'

describe "An instance of", PeptideSpectrumAssignment do

  before "built with factory girl" do 
    @psa = build(:peptide_spectrum_assignment)
  end

  it "should be properly initialized" do  
    @psa.should be_a(PeptideSpectrumAssignment)
  end

  it "should be valid  on FactoryGirl build" do
    @psa.should be_valid 
  end
 
  it "should be valid on FactoryGirl create" do
    create(:spectrum_identification_item).should be_valid
  end
 
  it "should be invalid without sii_id" do
    @psa.spectrum_identification_item_id = nil
    @psa.should_not be_valid
  end
 
  it "should be invalid without peptide_evidence_id" do
    @psa.peptide_evidence_id = nil
    @psa.should_not be_valid
  end
 
  it "should not be valid if there is already a psa with same sii_id and same peptide_evidence_id" do
    #without shoulda-matchers:
    #create(:peptide_spectrum_assignment, spectrum_identification_item_id: "mySIIid", peptide_evidence_id: "myPEPEVid")
    #build(:peptide_spectrum_assignment, spectrum_identification_item_id: "mySIIid", peptide_evidence_id: "myPEPEVid").should_not be_valid    
    #with should-matchers:
    @psa.should validate_uniqueness_of(:spectrum_identification_item_id).scoped_to(:peptide_evidence_id)
  end

  it "should belong to peptide evidence" do 
    @psa.should belong_to(:peptide_evidence)
  end

  it "should belong to spectrum identification item" do
     @psa.should belong_to(:spectrum_identification_item)
  end  


end


