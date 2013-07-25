class Admin::SpectraAcquisitionRunsController < ApplicationController

require 'nokogiri'

before_filter :require_login


def index

  @mzidf_input_spectra_files = MzidFile.spectra_files

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

 
  #~ Nokogiri::XML(File.open(mzidf.location)).xpath("//xmlns:SpectrumIdentification")

    #~ si_arr = []
    #~ @doc.xpath("//xmlns:SpectrumIdentification").each do |si|
      #~ si_id = si.attr("id")
      #~ sip_ref = si.attr("spectrumIdentificationProtocol_ref")
      #~ sil_ref = si.attr("spectrumIdentificationList_ref")
      #~ si_name ||= si.attr("name")
      #~ activity_date ||= si.attr("activityDate")
      #~ input_spectra_files_arr, search_db_arr = [] , [] #input_spectra_ref_arr es un arr de input_spectra hashes  #input_spectra = {} #[ {"SID_AtiO2" => "AtiO2.mzML"}, {"SID_Elu1A" => "Elu1A.mzML"}, {"SID_Elu2A" => "Elu2A.mzML"} ]
      #~ si.xpath(".//xmlns:InputSpectra").each do |i_s|
        #~ sd_id = i_s.attr("spectraData_ref")
        #~ spectra_data = @doc.xpath("//xmlns:SpectraData[@id='#{sd_id}']") #input_spectra[sd_id] = spectra_data.attr("location").to_s.split("/")[-1]
        #~ input_spectra_files_arr << spectra_data.attr("location").to_s.split("/")[-1]
      #~ end      
      #~ si.xpath(".//xmlns:SearchDatabaseRef").each do |sdb|
        #~ sdb_id = sdb.attr("searchDatabase_ref")
        #~ search_database = @doc.xpath("//xmlns:SearchDatabase[@id='#{sdb_id}']")[0]
        #~ name = get_cvParam_and_or_userParam(search_database.xpath(".//xmlns:DatabaseName"))
        #~ location, version = search_database.attr("location"), search_database.attr("version")
        #~ releaseDate, num_seq = search_database.attr("releaseDate"),  search_database.attr("numDatabaseSequences")
        #~ sdb = SearchDB.new(name, sdb_id, location, version, releaseDate, num_seq)
        #~ search_db_arr << sdb if search_db_arr.empty?
        #~ search_db_arr << sdb unless search_db_arr.include? sdb
      #~ end      
      #~ si_arr << Si.new(si_id, sip_ref, sil_ref, si_name, activity_date, input_spectra_files_arr, search_db_arr)
    #~ end



  #OPCION A:
  #Guardar aqui el SpectraAcquisitionRun, SIN su spectrum_identification_id y luego hacer un update
  
  #OPCION B:
  #Guardar antes el SpectrumIdentification para poder guardar el SpectraAcquistionRun con su sii_id
  #Por ahora me inclino más por esto:
  #Hacer admin/spectra_acquistion_runs nested así: admin/mzid_file/1/spectra_acquisiton_runs
  #Crear un nuevo controller spectrum_identifications también así: admin/mzid_file/1/spectrum_identifications



  @spectra_acquisition_run = SpectraAcquisitionRun.create(sar_params)
  
  if @spectra_acquisition_run.invalid?
    render "new"
  else
    redirect_to :action => :index
  end
  
end

private

  def sar_params
    params.require(:spectra_acquisition_run).permit(:fraction, :instrument, :ionization, :analyzer, :spectra_file, :mzid_file_id)
  end


end












