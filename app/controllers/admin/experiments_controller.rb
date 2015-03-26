class Admin::ExperimentsController < ApplicationController

  before_filter :require_login #, :only=> [:new, :create]
  
  load_and_authorize_resource
  
  
  def index 
    @experiments = Experiment.all

  end


  def new
    #@experiment = Experiment.new(:date => "2010-01-01".to_date)
    @experiment = Experiment.new
  end


  def create
    #@experiment = Experiment.create(params[:experiment])
    short_label = params[:experiment][:short_label]
    organism = params[:experiment][:organism] || "species not defined"
    protocol = params[:experiment][:protocol]
    protocol = nil if params[:experiment][:protocol] == ""
    researcher = params[:experiment][:researcher]
    month = params[:experiment]['date_m_y(2i)']
    #year = params[:experiment]['date_m_y(1i)']
    #date = params[:experiment][:date]
    #date = "#{year}/#{month}"
    #date = date.strftime("%m/%d/%Y")
    date = params[:experiment][:date]
    pmid = params[:experiment][:pmid]
    
    #@experiment = Experiment.create({:short_label => short_label, :organism => organism, :protocol => protocol, :date => date, :researcher => researcher})
    #strong_params ; Rails 4
    @experiment = Experiment.create(experiment_params)
    
    if @experiment.invalid?
      render :action => "new"
      #@experiment.date = Date.today
    else
      redirect_to :action => "index"
    end
  end
  
  private

  def experiment_params
    params.require(:experiment).permit(:short_label, :organism, :protocol, :date, :researcher, :pmid)
  end


  
end


