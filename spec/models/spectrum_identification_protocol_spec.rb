require 'spec_helper'

describe "An instance of", SpectrumIdentificationProtocol do

  before "built with factory girl" do 
    @sip = FactoryGirl.build(:spectrum_identification_protocol)
  end

  it "has a valid factory" do
    FactoryGirl.create(:spectrum_identification_protocol).should be_valid
  end

  it "should be properly initialized" do  
    expect(@sip).to be_a(SpectrumIdentificationProtocol)  
  end

  it "should be valid with the factoryGirl-build" do
   @sip.should be_valid 
  end

  it "should be invalid without sip_id" do
    @sip.sip_id = nil
    @sip.should_not be_valid
    expect(@sip).to have(1).errors_on(:sip_id)
  end

  it "should be invalid without search_type" do
    @sip.search_type = nil
    @sip.should_not be_valid
    @sip.should have(1).errors_on(:search_type)
    #expect(@si).to have(1).errors_on(:mzid_file_id)
  end

  it "should belong to SpectrumIdentification" do 
    @sip.should belong_to(:spectrum_identification)
  end


#  validates :spectrum_identification_id, uniqueness: {scope: :sip_id}, presence: true

    
end

