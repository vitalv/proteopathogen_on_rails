require 'spec_helper'

describe "An instance of", SpectrumIdentificationResult do

  before "built with factory girl" do 
    @sir = build(:spectrum_identification_result)
  end

  it "should be properly initialized" do  
    @sir.should be_a(SpectrumIdentificationResult)
  end

  it "should be valid  on FactoryGirl build" do
   @sir.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:spectrum_identification_result).should be_valid
  end
 
  it "should be invalid without sir_id" do
    @sir.sir_id = nil
    @sir.should_not be_valid
    #@sir.should have(1).errors_on(:sir_id)
  end
 
  it "should not be valid if there is already a sir with same sir_id for the sil it belongs to" do
    sil = create(:spectrum_identification_list)
    create(:spectrum_identification_result, spectrum_identification_list: sil, sir_id: "mySIR")
    duplicate_sir = build(:spectrum_identification_result, spectrum_identification_list: sil, sir_id: "mySIR")
    duplicate_sir.should_not be_valid
  end

  it "should belong to SpectrumIdentification" do 
    @sir.should belong_to(:spectrum_identification_list)
  end

  it "should have many spectrum_identification_items" do 
    @sir.should have_many(:spectrum_identification_items)
  end

end
