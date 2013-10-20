class SpectrumIdentificationResultsController < ApplicationController

  def index
    @si = SpectrumIdentification.find(params[:spectrum_identification_id])
    @protocol = @si.mzid_file.experiment.protocol
    @sil = @si.spectrum_identification_list
    #@protocol = Experiment.find(experiment_id).protocol
    #@spectra_acquisition_runs = SpectraAcquisitionRun.where(:mzid_file_id => params[:experiment_id])
    @spectrum_identification_results = @si.spectrum_identification_list.spectrum_identification_results
    
    respond_to do |format|
      format.html #“if the client wants HTML in response to this action, just respond as we would have before
      
      
      #@sir_datatable =  SpectrumIdentificationResultsDatatable.new(view_context, @spectrum_identification_results) 
      #sii_datatlable = 
      #json_response =  { :sir_datatable => @sir_datatable }
      format.json { 
        #render json: json_response
        render json: SpectrumIdentificationResultsDatatable.new(view_context, @spectrum_identification_results) 
        #render json: SpectrumIdentificationItemsDatatable.new(view_context, @spectrum_identification_results) 
        }
      #format.json { render json: @si}
    end
    
    
  end

end
