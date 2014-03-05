class Admin::ExperimentsController < ApplicationController

  before_filter :require_login #, :only=> [:new, :create]
  
  def index 
    @experiments = Experiment.all

  end


  def new
    #@experiment = Experiment.new(:date => "2010-01-01".to_date)
    @experiment = Experiment.new
  end


  def create
    #@experiment = Experiment.create(params[:experiment])
    organism = params[:experiment][:organism]
    protocol = params[:experiment][:protocol]
    researcher = params[:experiment][:researcher]
    month = params[:experiment]['date(2i)']
    year = params[:experiment]['date(1i)']
    date = params[:experiment][:date]
    
    @experiment = Experiment.create({:organism => organism, :protocol => protocol, :date => date, :researcher => researcher})
    
    if @experiment.invalid?
      render :action => "new"
      #@experiment.date = Date.today
    else
      redirect_to :action => "index"
    end
  end
  
end
