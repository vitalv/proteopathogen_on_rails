class SearchController < ApplicationController

  include PeptideProteinMapper


  def index
    #@experiments = Experiment.all
  end
  
  def show
    #@exp = Experiment.friendly.find(params[:id])
    #por que va a show
  end


  def query
    @query_thing = params[:search_field_tag_input]
    @query_thing.strip
    if @query_thing =~ /^orf19.+/
      db_seq = DbSequence.where('accession LIKE ?', @query_thing).take
      @db_seq_id = db_seq.id
      @db_sequence = db_seq.sequence
      @descr = db_seq.description
      @db_sequence_accession = db_seq.accession
      @database_name = db_seq.search_database.name
      @prot_peps_freq_hash = db_seq.pep_evidences_freq_hash #see method in DbSequence model
      peptide_sequences = db_seq.uniq_pep_sequences #see method in DbSequence model
      @sequence_coverage, @prot_seq_w_cov_tags = map_peptides_2_protein(db_seq, peptide_sequences) 
      
    else
      @not_found_string = "Sorry, your query #{@query_thing} did not retrieve any results"
    end
    
  end

end
