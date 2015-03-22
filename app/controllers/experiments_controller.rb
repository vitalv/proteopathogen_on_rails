class ExperimentsController < ApplicationController

  def index
    @experiments = Experiment.all
  end
  
  def show
    @exp = Experiment.friendly.find(params[:id])
  end

  def download_mzid_file
    mzid_file_name = MzidFile.find(params[:mzidf_id]).name
    send_file("#{Rails.root}/public/uploaded_mzid_files/#{mzid_file_name}", filename: "#{mzid_file_name}" ) 
    end
    #~ respond_to do |format|
     #~ format.js { render :layout => false }
   #~ end

end
