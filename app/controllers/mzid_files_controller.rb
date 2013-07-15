class MzidFilesController < ApplicationController
  
  def index 
    @all_mzid_files = MzidFile.all
  end

end
