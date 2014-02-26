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
      
      @instruments = PsiMsCvTerm.where("name REGEXP ?", "trap|orbi|thermo|tof")
      @ionization_types = PsiMsCvTerm.where("name REGEXP ?", "ionization")
      analyzers_acs = ["MS:1000079", "MS:1000080", "MS:1000081", "MS:1000084", "MS:1000254", "MS:1000264", "MS:1000284", "MS:1000288" , "MS:1000484"]
      @analyzers = Array.new
      analyzers_acs.each { |a| @analyzers << PsiMsCvTerm.where(accession: a)}
      
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

