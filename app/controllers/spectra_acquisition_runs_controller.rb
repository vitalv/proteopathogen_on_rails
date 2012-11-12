class SpectraAcquisitionRunsController < ApplicationController

require 'nokogiri'

before_filter :require_login


def index

  #get this from the mzid file
  input_spect_files = []
  mzidf_input_spectra_files_hash = {}
  @mzidf_input_spectra_files = [] #Array of hashes [ { mzidf_id => [Ati02.mzml, Elu1A.mzml, Elu2B.mzml] } , {} ...   ]

  #get this from existing mzidfile.spectra_acquisition_runs
  spect_acq_runs, @stored_spectra_files = [], []
  
  MzidFile.find(:all).each do |mzidf|
    if File.exists? mzidf.location
      spect_acq_runs = MzidFile.find(mzidf).spectra_acquisition_runs
      if !spect_acq_runs.blank?
        spect_acq_runs.each do |sar|
          @stored_spectra_files << sar.spectra_file
        end
      end
      Nokogiri::XML(File.open(mzidf.location)).xpath("//xmlns:SpectraData").each do |s|
        input_spect_files << s.attr("location").split("/")[-1]
      end
      mzidf_input_spectra_files_hash[mzidf.id] = input_spect_files
      @mzidf_input_spectra_files << mzidf_input_spectra_files_hash
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
