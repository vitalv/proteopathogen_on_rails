require 'spec_helper'

describe "An instance of", SpectrumIdentificationList do

  before "built with factory girl" do 
    @sil = build(:spectrum_identification_list)
  end

  it "has a valid factory" do
    create(:spectrum_identification_list).should be_valid
  end

  it "should be properly initialized" do  
    expect(@sil).to be_a(SpectrumIdentificationList)
  end

  it "should be valid with the factoryGirl-build" do
   @sil.should be_valid 
  end

  it "should be invalid without sil_id" do
    @sil.sil_id = nil
    @sil.should_not be_valid
    expect(@sil).to have(1).errors_on(:sil_id)
  end

  it "should not be valid if there is already a sil with same sil_id for the si it belongs to" do
    si = create(:spectrum_identification)
    create(:spectrum_identification_list, spectrum_identification: si, sil_id: "SIL_1")
    dup_sil = build(:spectrum_identification_list, spectrum_identification: si, sil_id: "SIL_1")
    dup_sil.should_not be_valid
  end

  it "should belong to SpectrumIdentification" do 
    @sil.should belong_to(:spectrum_identification)
  end

  it "should belong to ProteinDetection" do 
    @sil.should belong_to(:protein_detection)
  end
    
end

