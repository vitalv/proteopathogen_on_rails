class Admin::SpectraAcquisitionRunsController < ApplicationController

require 'nokogiri'

before_filter :require_login


def index

  @mzidf_input_spectra_files = MzidFile.spectra_files 
  #HASH: {4=>["AtiO2.mzML", "Elu1A.mzML", "Elu2A.mzML"], 5=>["MYOGLOBIN_ECD.mgf"]}
  
   ##get this from existing mzidfile.spectra_acquisition_runs
   #spect_acq_runs, @stored_spectra_files = [], []
   
   #@si_sars = {}
   
   #MzidFile.all.each do |mzidf|
     #get this from the mzid file
     #input_spect_files = []  
     #if File.exists? mzidf.location
       #mzidf.spectrum_identifications.collect do |si|
         #s_files = []
         #si.spectra_acquisition_runs.each { |sar| s_files << sar.spectra_file }
         #@si_sars[si.id] = s_files
       #end
       #
       #mzidf.spectrum_identifications.collect { |si| spect_acq_runs = si.spectra_acquisition_runs }
       #unless spect_acq_runs.blank?
         #spect_acq_runs.each do |sar|
           #@stored_spectra_files << sar.spectra_file
         #end
       #end
#
     #end    
   #end
#

end



def new
  
  if params[:mzid_file_id] and params[:input_spectra_file]
    @mzid_file_id = params[:mzid_file_id] 
    @mzid_file = MzidFile.find(params[:mzid_file_id])    
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
    redirect_to :index
  end
  
end

private

  def sar_params
    params.require(:spectra_acquisition_run).permit(:fraction, :instrument, :ionization, :analyzer, :spectra_file, :mzid_file_id)
  end


end












