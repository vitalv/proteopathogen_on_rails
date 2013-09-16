require 'spec_helper'

describe SpectrumIdentificationsController do
 
  describe "GET experiments/:experiment_id/spectrum_identifications#index " do
  
    before(:each) do    
      @mzidf = FactoryGirl.create(:mzid_file)
      get :index, experiment_id: @mzidf.id  
    end
  
    it "gets list of si_s for the corresponding experiment" do       
      #get :index, experiment_id: mzidf.id  
      assigns(:spectrum_identifications).should eq(@mzidf.spectrum_identifications)
    end
   
    it "gets the protocol for the corresponding experiment" do
      experiment_id = @mzidf.experiment.id
      exp_protocol = Experiment.find(experiment_id).protocol
      assigns(:exp_protocol).should eq(exp_protocol)
    end
    
    print page.html
    
  end
    
    #~ mzid_file_id = params[:experiment_id]
    #~ experiment_id = MzidFile.find(mzid_file_id).experiment_id
    #~ @exp_protocol = Experiment.find(experiment_id).protocol

    #~ @spectrum_identifications = MzidFile.find(mzid_file_id).spectrum_identifications
  
  

end

