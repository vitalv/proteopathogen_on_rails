class ExperimentsController < ApplicationController

  def index
 
    @all_experiments = Experiment.find(:all)
 
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
      redirect_to experiment_spectra_acquisition_runs_path(saved_experiment_id) #this goes to experiment/:id/spectra_acquisition_runs/index
    end

  end




end
