require 'spec_helper'

describe SpectrumIdentificationResultsController do
 
  describe "GET spectrum_identifications/:spectrum_identification_id/spectrum_identification_results#index " do
  
    before "given I have a sil for the si, and sir_s for the sil" do
    #- (Should I only save sil for already saved sir_s and si for already saved sil_s and so on... ???
      @si = FactoryGirl.create(:spectrum_identification)
      @si.spectrum_identification_list = FactoryGirl.create(:spectrum_identification_list)
      sil = @si.spectrum_identification_list
      @si.spectrum_identification_list.spectrum_identification_results = [FactoryGirl.create(:spectrum_identification_result)]
      @sirs = sil.spectrum_identification_results
      get :index, spectrum_identification_id: @si.id
    end
    
    it "generates list of sir_s for the corresponding  si" do
      assigns(:spectrum_identification_results).should eq(@sirs)
    end
   
    
  end    


end


