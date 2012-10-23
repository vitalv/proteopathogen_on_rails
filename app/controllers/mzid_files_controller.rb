require 'nokogiri'

class MzidFilesController < ApplicationController

  def index 
  
    @all_mzid_files = MzidFile.find(:all)
  
  end

  def new
   
    @mzid_file = MzidFile.new
   
  end

  def create

  # Depending on the size of the uploaded file it may in fact be a StringIO or an instance of File backed by a temporary file- SEE guides/form_helpers
  # In both cases the object will have an original_filename attribute containing the name the file had on the user’s computer and a content_type attribute containing the MIME type of the uploaded file
  # CHECK uploaded mzid file # SIPS == biological_sample.spectra_acquisition_runs.count
  
    uploaded_io = params[:mzid_file][:uploaded_file]
    uploaded_io_filename = uploaded_io.original_filename
    File.open(Rails.root.join('public', 'uploaded_mzid_files', uploaded_io_filename), 'w') do |file|
      file.write(uploaded_io.read)
    end
    uploaded_mzid_file = File.new("#{Rails.root}/public/uploaded_mzid_files/#{uploaded_io_filename}")
    @location = File.absolute_path(uploaded_mzid_file)
    @name = uploaded_io_filename
    @sha1 = Digest::SHA1.hexdigest("#{Rails.root}/public/uploaded_mzid_files/#{uploaded_io_filename}")
    Nokogiri::
  
  

  
  end

end
