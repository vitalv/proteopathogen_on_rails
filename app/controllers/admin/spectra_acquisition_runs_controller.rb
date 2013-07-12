class Admin::SpectraAcquisitionRunsController < ApplicationController

require 'nokogiri'

before_filter :require_login


def index

  @mzidf_input_spectra_files = {} #HASH: {4=>["AtiO2.mzML", "Elu1A.mzML", "Elu2A.mzML"], 5=>["MYOGLOBIN_ECD.mgf"]}
 
  #get this from existing mzidfile.spectra_acquisition_runs
  spect_acq_runs, @stored_spectra_files = [], []
  
  MzidFile.find(:all).each do |mzidf|
    #get this from the mzid file
    input_spect_files = []  
    if File.exists? mzidf.location
      spect_acq_runs = MzidFile.find(mzidf).spectra_acquisition_runs
      unless spect_acq_runs.blank?
         spect_acq_runs.each do |sar|
          @stored_spectra_files << sar.spectra_file
        end
      end
      spectra_data = Nokogiri::XML(File.open(mzidf.location)).xpath("//xmlns:SpectraData")
      spectra_data.each do |s| #<SpectraData> minOccurs = 1
        input_spect_files << s.attr("location").split("/")[-1] #attr location required
      end
      @mzidf_input_spectra_files[mzidf.id] = input_spect_files
    end    
  end

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
  spectra_data_hash = params[:spectra_acquisition_run]
  spectra_data_hash[:spectra_file] = params[:spectra_acquisition_run][:spectra_file]
  spectra_data_hash[:mzid_file_id] = params[:spectra_acquisition_run][:mzid_file_id]
  @spectra_acquisition_run = SpectraAcquisitionRun.create(spectra_data_hash)
  
  if @spectra_acquisition_run.invalid?
    render "new"
  else
    redirect_to :action => :index
  end
  
end


end
