class SamplesController < ApplicationController

def index

end


def new
  @sample = Sample.new
  #Aqui es donde pondre el formulario, un boton para subir el mzid y correr mi codigo save2tables
  #En el view new es donde puedo poner fields_for spectra_acq_run bajo form_for @sample
end

def create

  @saved_sample = Sample.create(params[:sample])
  if @saved_sample.invalid?
    @saving_sample_errors = @saved_sample.errors
    @sample = @saved_sample
    render :action => "new"
  else
    saved_sample_id = @saved_sample.id
    redirect_to sample_spectra_acquisition_runs_path(saved_sample_id) #this goes to sample/:id/spectra_acquisition_runs/index
  end

end


end
