class ExperimentsController < ApplicationController

  before_filter :require_login, :only=> [:new, :create]
  
  def index 
    @experiments = Experiment.:all
  end


  def new
    @experiment = Experiment.new  
  end


  def create
    #@experiment = Experiment.create(params[:experiment])
    organism = params[:experiment][:organism]
    protocol = params[:experiment][:protocol]
    researcher = params[:experiment][:researcher]
    date = "#{params[:experiment]['date(2i)']} - #{params[:experiment]['date(1i)']}"
    
    @experiment = Experiment.create({:organism => organism, :protocol => protocol, :date => date, :researcher => researcher})
    
    if @experiment.invalid?
      render :action => "new"
    else
      redirect_to :action => "index"
    end
  end
  
end
