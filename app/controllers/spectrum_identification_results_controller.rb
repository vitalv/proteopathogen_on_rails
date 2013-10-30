class SpectrumIdentificationResultsController < ApplicationController

  def index
    @si = SpectrumIdentification.find(params[:spectrum_identification_id])
    @protocol = @si.mzid_file.experiment.protocol
    @sil = @si.spectrum_identification_list

    @spectrum_identification_results = @si.spectrum_identification_list.spectrum_identification_results
    
    @spectrum_identification_items = SpectrumIdentificationResult.find(19186).spectrum_identification_items
    
    respond_to do |format|
      format.html #“if the client wants HTML in response to this action, just respond as we would have before
      format.json { 

        render json: SpectrumIdentificationResultsDatatable.new(view_context, @spectrum_identification_results) 

        }
      #format.xhr { @sir_id = params[:sir_id] }
    end
    
    
  end
  
  def show
    @sir_id = params[:id]
    @spectrum_identification_items = SpectrumIdentificationResult.find(@sir_id).spectrum_identification_items

    #render partial: "spectrum_identification_items", locals: {siis: @spectrum_identification_items}

  end
  
  

end
