#require 'nokogiri'
#~ require 'mzid_parser'
#~ require 'mzid_2_db'

class MzidFilesController < ApplicationController

  before_filter :require_login

  def index 

    #@experiment_id ||= params[:experiment_id]
    @all_mzid_files = MzidFile.find(:all)
  
  end

  def new
  
    #@experiment_id ||= params[:experiment_id] 
    #@protocols = []
    #Experiment.find(:all).each { |e| @protocols << e.protocol.slice(0..30) }
    @experiments = Experiment.find(:all)
    @mzid_file = MzidFile.new
   
  end

  def create
  # Depending on the size of the uploaded file it may in fact be a StringIO or an instance of File backed by a temporary file- SEE guides/form_helpers
    @experiment_id = params[:mzid_file][:experiment_id]
    uploaded_io = params[:mzid_file][:uploaded_file]
    uploaded_io_filename = uploaded_io.original_filename
    File.open(Rails.root.join('public', 'uploaded_mzid_files', uploaded_io_filename), 'w') do |file|
      file.write(uploaded_io.read)
    end
    uploaded_mzid_file = File.new("#{Rails.root}/public/uploaded_mzid_files/#{uploaded_io_filename}")
    location = File.absolute_path(uploaded_mzid_file)
    name = uploaded_io_filename
    sha1 = Digest::SHA1.hexdigest("#{Rails.root}/public/uploaded_mzid_files/#{uploaded_io_filename}")
    @saved_mzid = MzidFile.find_or_create_by_sha1({:location => location, :sha1 => sha1, :name => name, :submission_date => Date.today, :experiment_id => @experiment_id})

    
    if @saved_mzid.invalid? #could add validation in the model to check file extension really is .mzid
      render "new"
    else
      redirect_to :action =>  :index
      @errors = @saved_mzid.errors
    end

      
  
  end


  
  
  #~ def load_mzid_data_into_tables
  #~ 
    #~ @sample_id = params[:sample_id]
    #~ saved_mzid_id = params[:saved_mzid_id]
    #~ saved_mzid = MzidFile.find(saved_mzid_id)
    #~ location = saved_mzid.location
    #~ 
    #~ mzid_object = Mzid.new(location)
 #~ 
    #~ Mzid2db.new(mzid_object, saved_mzid_id).save2tables
    #~ rescue Exception => msg
      #~ @exc = msg
      #~ @trace = msg.backtrace.inspect
      #~ rollback(@sample_id) if Sample.exists? @sample_id #sometimes I might refresh the view with the "load .mzid file" button when the sample_id was already destroyed in rollback
      #~ render :rescue
#~ 
  #~ end

end
