class ExperimentsController < ApplicationController

  before_filter :require_login, :only=> [:new, :create]
  
  def index
 
    @experiments = Experiment.find(:all)
 
  end


  def new

    @experiment = Experiment.new
  
  end


  def create

    @saved_experiment = Experiment.create(params[:experiment])
    if @saved_experiment.invalid?
      @saving_experiment_errors = @saved_experiment.errors
      @experiment = @saved_experiment
      render :action => "new"
    else
      saved_experiment_id = @saved_experiment.id
      #redirect_to mzid_files_path :params => {:experiment_id => saved_experiment_id}
      redirect_to :action => "index"
    end

  end

end
