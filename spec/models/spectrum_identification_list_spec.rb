require 'spec_helper'

describe "An instance of", SpectrumIdentificationList do

  before "built with factory girl" do 
    @sil = FactoryGirl.build(:spectrum_identification_list)
  end

  it "has a valid factory" do
    FactoryGirl.create(:spectrum_identification_list).should be_valid
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
    pending
    #~ @sip.search_type = nil
    #~ @sip.should_not be_valid
    #~ @sip.should have(1).errors_on(:search_type)
    #~ #expect(@si).to have(1).errors_on(:mzid_file_id)
  end

  #~ it "should belong to SpectrumIdentification" do 
    #~ @sip.should belong_to(:spectrum_identification)
  #~ end


#  validates :spectrum_identification_id, uniqueness: {scope: :sip_id}, presence: true

    
end

