require 'spec_helper'

describe SpectrumIdentificationsController do
 
  describe "GET experiments/:experiment_id/spectrum_identifications#index " do
  
    before(:each) do
      @mzidf = FactoryGirl.create(:mzid_file)  
      @mzidf.spectrum_identifications = [FactoryGirl.create(:spectrum_identification)]
      get :index, mzid_file_id: @mzidf.id  
    end
   
    it "gets list of si_s for the corresponding mzid file" do
      @mzidf.spectrum_identifications.should_not be_empty
      assigns(:spectrum_identifications).should eq(@mzidf.spectrum_identifications)
    end
    
    #~ it "gets the protocol for the corresponding experiment" do
      #~ exp_protocol = Experiment.find(@mzidf.experiment.id).protocol
      #~ assigns(:exp_protocol).should eq(exp_protocol)
    #~ end
    #~ 
    
  end
    


end

