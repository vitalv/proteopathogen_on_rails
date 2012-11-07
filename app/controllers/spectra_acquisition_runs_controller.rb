class SpectraAcquisitionRunsController < ApplicationController

require 'nokogiri'

before_filter :require_login, :only=> [:new, :create]


def index
  @mzid_file_id = params[:mzid_file_id]
  if MzidFile.find(@mzid_file_id)
    @spectra_acquisition_runs = MzidFile.find(@mzid_file_id).spectra_acquisition_runs
    @mzid_file_name = MzidFile.find(@mzid_file_id).name
  end
end


def new
  @mzid_file = MzidFile.find(params[:mzid_file_id])
  
  @mzid_file_name = @mzid_file.name
  mzid_file_path = @mzid_file.location
  @input_spectra_files = []
  Nokogiri::XML(File.open(mzid_file_path)).xpath("//xmlns:SpectraData").each do |s|
    @input_spectra_files << s.attr("location").split("/")[-1]
  end
  
  @spectra_acquisition_runs = @mzid_file.spectra_acquisition_runs.build
  
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
