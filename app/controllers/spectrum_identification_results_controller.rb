class SpectrumIdentificationResultsController < ApplicationController

  def index
    @si = SpectrumIdentification.find(params[:spectrum_identification_id])
    @protocol = @si.mzid_file.experiment.protocol
    @sil = @si.spectrum_identification_list
    #@protocol = Experiment.find(experiment_id).protocol
    #@spectra_acquisition_runs = SpectraAcquisitionRun.where(:mzid_file_id => params[:experiment_id])
    @spectrum_identification_results = @si.spectrum_identification_list.spectrum_identification_results
    
    @spectrum_identification_items = SpectrumIdentificationResult.find(19186).spectrum_identification_items
    
    #@clicked_sir_id = @clicked_sir_id
    
    respond_to do |format|
      format.html #“if the client wants HTML in response to this action, just respond as we would have before
      
      @sir_table = SpectrumIdentificationResultsDatatable.new(view_context, @spectrum_identification_results) 
      #@sii_table = SpectrumIdentificationItemsDatatable.new(view_context, @spectrum_identification_items) 
      format.json {
        #render :json => {:sir_table => @sir_table} #, :sii_table => @sii_table}
        render json: SpectrumIdentificationResultsDatatable.new(view_context, @spectrum_identification_results) 
        #render json: {:sir_table => @sir_table, :sii_table => @sii_table}
        #render json: SpectrumIdentificationItemsDatatable.new(view_context, @spectrum_identification_results) 
        }
      #format.xhr { }
    end
    
    
  end

end
