#require 'nokogiri'
require 'mzid_parser'
require 'mzid_2_db'

class MzidFilesController < ApplicationController

  def index 
  
    @all_mzid_files = MzidFile.find(:all)
  
  end

  def new
   
    @mzid_file = MzidFile.new
   
  end

  def create
  # Depending on the size of the uploaded file it may in fact be a StringIO or an instance of File backed by a temporary file- SEE guides/form_helpers
    @sample_id = params[:sample_id]
    uploaded_io = params[:mzid_file][:uploaded_file]
    uploaded_io_filename = uploaded_io.original_filename
    File.open(Rails.root.join('public', 'uploaded_mzid_files', uploaded_io_filename), 'w') do |file|
      file.write(uploaded_io.read)
    end
    uploaded_mzid_file = File.new("#{Rails.root}/public/uploaded_mzid_files/#{uploaded_io_filename}")
    location = File.absolute_path(uploaded_mzid_file)
    name = uploaded_io_filename
    sha1 = Digest::SHA1.hexdigest("#{Rails.root}/public/uploaded_mzid_files/#{uploaded_io_filename}")
    @saved_mzid = MzidFile.find_or_create_by_sha1({:location => location, :sha1 => sha1, :name => name, :submission_date => Date.today})
  
  end
  
  
  def load_mzid_data_into_tables
  
    @sample_id = params[:sample_id]
    saved_mzid_id = params[:saved_mzid_id]
    saved_mzid = MzidFile.find(saved_mzid_id)
    location = saved_mzid.location
    
    mzid_object = Mzid.new(location)
 



   #--------------------------------
      #~ sip = mzid_object.sips[0]
      #~ sip_id = sip.sip_id
      #~ input_spectra = sip.input_spectra      
      #~ analysis_software = sip.analysis_software
      #~ search_type = sip.search_type
      #~ threshold = sip.threshold      
      #~ search_db_arr = sip.search_db_arr
      #~ searched_mod_arr = sip.searched_modification_arr
      #~ psi_ms_terms = sip.psi_ms_terms
      #~ parent_tol_plus_value, parent_tol_minus_value = sip.parent_tolerance[0][:value], sip.parent_tolerance[1][:value]
      #~ fragment_tol_plus_value, fragment_tol_minus_value = sip.fragment_tolerance[0][:value], sip.fragment_tolerance[1][:value]
      #~ user_params = sip.user_params
      #~ spectra_acquisition_run_id = SpectraAcquisitionRun.find_by_spectra_file(input_spectra).id 
      #~ @this_sip = SpectrumIdentificationProtocol.create(:sip_id => sip_id, :input_spectra => input_spectra, :spectra_acquisition_run_id => spectra_acquisition_run_id, :analysis_software => analysis_software, :search_type => search_type, :threshold => threshold, :parent_tol_plus_value => parent_tol_plus_value, :parent_tol_minus_value => parent_tol_minus_value, :fragment_tol_plus_value => fragment_tol_plus_value, :fragment_tol_minus_value => fragment_tol_minus_value, :mzid_file_id => saved_mzid_id)   
   #--------------------------------





 
    Mzid2db.new(mzid_object, saved_mzid_id).save2tables
#    rescue Exception => msg
#      puts "\n#{msg}"
#      rollback(@sample_id)

  end

end
