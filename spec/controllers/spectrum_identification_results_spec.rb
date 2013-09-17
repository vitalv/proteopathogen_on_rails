require 'spec_helper'

describe SpectrumIdentificationsController do
 
  describe "GET spectrum_identifications/:spectrum_identification_id/spectrum_identification_results#index " do
  
    #before(:each) do    
    #  @mzidf = FactoryGirl.create(:mzid_file)
    #  get :index, experiment_id: @mzidf.id  
    #end
   si = FactoryGirl.create(:spectrum_identification)
   get :index, spectrum_identification_id: si.id
   
    #~ it "gets list of si_s for the corresponding experiment" do       
      #~ assigns(:spectrum_identifications).should eq(@mzidf.spectrum_identifications)
    #~ end
   #~ 
    #~ it "gets the protocol for the corresponding experiment" do
      #~ exp_protocol = Experiment.find(@mzidf.experiment.id).protocol
      #~ assigns(:exp_protocol).should eq(exp_protocol)
    #~ end
    #~ 
    
  end
    


end


