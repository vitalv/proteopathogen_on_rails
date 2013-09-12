require 'spec_helper'

describe "An instance of", SpectrumIdentificationItem do

  before "built with factory girl" do 
    @sii = build(:spectrum_identification_item)
  end

  it "should be properly initialized" do  
    @sii.should be_a(SpectrumIdentificationItem)
  end

  it "should be valid  on FactoryGirl build" do
   @sii.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:spectrum_identification_item).should be_valid
  end
 
  it "should be invalid without sii_id" do
    @sii.sii_id = nil
    @sii.should_not be_valid
    #@sir.should have(1).errors_on(:sir_id)
  end

  it "should be invalid without charge_state" do
    @sii.charge_state = nil
    @sii.should_not be_valid
  end

  it "should be invalid without exp_m2z" do
    @sii.exp_m2z = nil
    @sii.should_not be_valid
  end
 
  it "should not be valid if there is already a sii with same sii_id for the sir it belongs to" do
    sir = create(:spectrum_identification_result)
    create(:spectrum_identification_item, spectrum_identification_result: sir, sii_id: "mySII")
    duplicate_sii = build(:spectrum_identification_item, spectrum_identification_result: sir, sii_id: "mySII")
    duplicate_sii.should_not be_valid
  end

  it "should belong to SpectrumIdentificationResult" do 
    @sii.should belong_to(:spectrum_identification_result)
  end

  it "should have many fragments" do 
    pending "still have to create the fragment factory"
  end
  
  it "should have many peptide_evidences" do
    @sii.should have_many(:peptide_evidences).through(:peptide_spectrum_assignments)
    
  end  


end


