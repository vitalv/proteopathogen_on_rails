class SearchController < ApplicationController

  def index
    #@experiments = Experiment.all
  end
  
  def show
    #@exp = Experiment.friendly.find(params[:id])
    #por que va a show
  end


  def query
    @query_thing = params[:search_field_tag_input]
    if @query_thing =~ /^orf19.+/
      @db_seq_id = DbSequence.where('accession LIKE ?', @query_thing).take.id
      @db_sequence = DbSequence.where('accession LIKE ?', @query_thing).take.sequence
      @descr = DbSequence.where('accession LIKE ?', @query_thing).take.description
      @db_sequence_accession = DbSequence.where('accession LIKE ?', @query_thing).take.accession
      @database_name = DbSequence.where('accession LIKE ?', @query_thing).take.search_database.name
      @prot_peps_freq_hash = DbSequence.where(accession: @query_thing).take.pep_evidences_freq_hash

    end
    
  end

end
