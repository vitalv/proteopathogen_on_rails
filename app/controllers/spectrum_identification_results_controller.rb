class SpectrumIdentificationResultsController < ApplicationController

  def index
  
    @si = SpectrumIdentification.find(params[:spectrum_identification_id])
    @protocol = @si.mzid_file.experiment.protocol
    @sil = @si.spectrum_identification_list
    @spectrum_identification_results = @si.spectrum_identification_list.spectrum_identification_results
    respond_to do |format|
      format.html #“if the client wants HTML in response to this action, just respond as we would have before
      format.json { 
        render json: SpectrumIdentificationResultsDatatable.new(view_context, @spectrum_identification_results) 
        }
    end
     
  end
  
  
  def show
  
    @sir_id = params[:id]
    @spectrum_identification_items = SpectrumIdentificationResult.find(@sir_id).spectrum_identification_items

    respond_to do |format|
      #format.html
      format.js
      #format.json {
        #render json: SpectrumIdentificationItemsDatatable.new(view_context, @spectrum_identification_items) 
      #  render json: SpectrumIdentificationItemsDatatable.new(view_context, @sir_id) 
        #render partial: "show"
      #}
    end
    
    #render partial: "show"
    
  end
  
  

end
