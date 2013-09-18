class SpectrumIdentificationResultsController < ApplicationController

  def index
    @si = SpectrumIdentification.find(params[:spectrum_identification_id])
    @protocol = @si.mzid_file.experiment.protocol
    @sil = @si.spectrum_identification_list
    #@protocol = Experiment.find(experiment_id).protocol
    #@spectra_acquisition_runs = SpectraAcquisitionRun.where(:mzid_file_id => params[:experiment_id])
    @spectrum_identification_results = @si.spectrum_identification_list.spectrum_identification_results
  end

end
