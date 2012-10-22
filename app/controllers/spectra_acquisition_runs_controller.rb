class SpectraAcquisitionRunsController < ApplicationController

def index

  if Sample.find(params[:sample_id])
    @spectra_acquisition_runs = Sample.find(params[:sample_id]).spectra_acquisition_runs
  end

end

def new
  @sample_id = params[:sample_id]
  @spectra_acquisition_run = SpectraAcquisitionRun.new
end

def create

  #params[:spectra_acquisition_run] is a hash with keys :fraction, :instrument, :ionization, etc...

end


end
