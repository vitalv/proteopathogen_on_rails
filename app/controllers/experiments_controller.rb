class ExperimentsController < ApplicationController

  before_filter :require_login, :only=> [:new, :create]
  
  def index 
    @experiments = Experiment.find(:all) 
  end


  def new
    @experiment = Experiment.new  
  end


  def create
    @experiment = Experiment.create(params[:experiment])
    if @experiment.invalid?
      render :action => "new"
    else
      redirect_to :action => "index"
    end
  end
  
end
