class SpectrumIdentificationProtocolsController < ApplicationController

  def index
    @mzid_file_id = params[:experiment_id]
    experiment_id = MzidFile.find(params[:experiment_id]).experiment_id
    @protocol = Experiment.find(experiment_id).protocol
    @spectra_acquisition_runs = SpectraAcquisitionRun.where(:mzid_file_id => params[:experiment_id])
    #@
  end

end
