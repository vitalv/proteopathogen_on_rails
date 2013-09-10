class MzidFilesController < ApplicationController
  
  extend Forwardable
  def_delegator :@all_mzid_files, :empty?
  
  def index 
    @all_mzid_files = MzidFile.all
  end

end
