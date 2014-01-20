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
    @sir_id_name = SpectrumIdentificationResult.find(@sir_id).sir_id
    @spectrum_identification_items = SpectrumIdentificationResult.find(@sir_id).spectrum_identification_items
    respond_to do |format|
      format.html 
      format.js { render  :layout => false } 
    end
  end
  
  
  def identification_item
    @sii = params[:sii_id]
    @fragments = SpectrumIdentificationItem.find(@sii).fragments
    #render json: @fragments
    respond_to do |format|
      format.html { render json: @fragments}
      #format.any { render json: @fragments }
      format.js { render json: @fragments }
    end
  end

end
