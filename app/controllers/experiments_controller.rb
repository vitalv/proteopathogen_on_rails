class ExperimentsController < ApplicationController

  def index
    @experiments = Experiment.all
  end
  
  def show
    @exp = Experiment.friendly.find(params[:id])
  end

end
