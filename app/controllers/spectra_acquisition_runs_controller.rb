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
  msrun_hash = params[:spectra_acquisition_run]
  msrun_hash[:sample_id] = params[:sample_id]
  @saved_msrun = SpectraAcquisitionRun.create(msrun_hash)
  if @saved_msrun.invalid?
    @saving_msrun_errors = @saved_msrun.errors
    @spectra_acquisition_run = @saved_msrun
    render :action => "new"
  else
    @all_saved_msruns = Sample.find(params[:sample_id]).spectra_acquisition_runs
        #en el view create pongo el recien salvado msrun y pregunto si crear nuevo msrun o, si ya no quiero mas msruns -> ir a load mzidentml
  end
end


end
