class Admin::MzidFilesController < ApplicationController

  before_filter :require_login

  def index 
    @experiments = Experiment.all
    @all_mzid_files = MzidFile.all
  end

  def new
    @experiments = Experiment.all
    @mzid_file = MzidFile.new
    @experiment_protocols = []
    @experiments.each {|e| @experiment_protocols << e.protocol}
  end

  def create
  # Depending on the size of the uploaded file it may in fact be a StringIO or an instance of File backed by a temporary file- SEE guides/form_helpers
    if params[:mzid_file] and params[:mzid_file][:uploaded_file]
    
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
    
      @mzid_file = MzidFile.find_or_create_by(sha1: sha1, location: location, name: name) do |mzidf|
        #mzidf.location = location,
        #mzidf.name = name,
        mzidf.submission_date = Date.today
        mzidf.experiment_id = @experiment_id
      end

      if @mzid_file.invalid? #could add validation in the model to check file extension really is .mzid
        @experiments = Experiment.all
        render "new"
      else
        redirect_to :action =>  :index
      end
    
    else
      redirect_to :action => :new
    end

  end

  def load2db
    
    load 'mzid_parser.rb' #this goes here so I can make changes to this file and see results after require this file just once
    load 'mzid_2_db.rb'
    mzid_file_id = params[:id]
    mzid_file = MzidFile.find(mzid_file_id)
    mzid = Mzid.new(mzid_file.location)
    #mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid")
    #mzid = Mzid.new("/home/vital/pepXML_protXML_2_mzid_V/examplefile.mzid")
    #mzid = Mzid.new("/home/vital/SeattleThings/PeptideAtlasExperiments_mzIdentML/CandidaRotofor-1.pep.mzid")
     
    Mzid2db.new(mzid).save2tables
    rescue Exception => msg
      @exc = msg
      @trace = msg.backtrace.inspect
      rollback(mzid_file_id) if MzidFile.exists? mzid_file_id #sometimes I might refresh the view with the "load .mzid file" button when the mzid_file_id was already destroyed in rollback
      render :rescue
  
    #respond_to do |format|
    #  format.js {
        #Mzid2db.new(mzid).save2tables
        #render layout: false
    #  }
    #  format.html
    #end
  
    #redirect_to :action =>  :index
    #render :js => 

  
  end

  

end
