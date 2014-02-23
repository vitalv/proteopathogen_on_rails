class Admin::SpectraAcquisitionRunsController < ApplicationController

  require 'nokogiri'

  before_filter :require_login

  def index

    @mzid_files = MzidFile.all

  end



  def new
  
    if params[:si_id] and params[:input_spectra_file]
      @si_id = params[:si_id] 
      @input_spectra_file = params[:input_spectra_file]
      @spectra_acquisition_run = SpectraAcquisitionRun.new
    else   
      redirect_to :action => :index
    end
  
  end


  def create

    @spectra_acquisition_run = SpectraAcquisitionRun.create(sar_params)
  
    if @spectra_acquisition_run.invalid?
      render "new"
    else
      redirect_to :action => :index
    end
  
  end


  private

  def sar_params
    params.require(:spectra_acquisition_run).permit(:fraction, :instrument, :ionization, :analyzer, :spectra_file, :spectrum_identification_id)
  end


end

