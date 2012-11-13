class LoadMzidFileIntoDatabaseController < ApplicationController
 
  require 'nokogiri'
  require 'mzid_parser.rb'  
  require 'mzid_2_db.rb'


  before_filter :require_login

  def index
   
  end

  def new
    @mzid_files = MzidFile.find(:all)
    @options_for_select = []
    @mzid_files.each do |m|
      @options_for_select << [m.name, m.id]
    end
  end
  
  
  def create
    load 'mzid_parser.rb' #this goes here so I can make changes to this file and see results after require this file just once
    load 'mzid_2_db.rb'
    mzid_file_id = params[:mzid_file_id]
    
    mzid_file = MzidFile.find(mzid_file_id)
    mzid_object = Mzid.new(mzid_file.location)
    
    Mzid2db.new(mzid_object).save2tables
    rescue Exception => msg
      @exc = msg
      @trace = msg.backtrace.inspect
      rollback(mzid_file_id) if MzidFile.exists? mzid_file_id #sometimes I might refresh the view with the "load .mzid file" button when the mzid_file_id was already destroyed in rollback
      render :rescue
  
    
  end

end
