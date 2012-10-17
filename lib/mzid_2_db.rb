class Mzid2db

  def initialize(mzid_object)
    @mzid_obj = mzid_object
  end

  def save2tables
    

    @mzid_obj.sips.each do |sip|
    
      sip_id = sip.sip_id
      input_spectra = sip.input_spectra
      analysis_software = sip.analysis_software
      search_type = sip.search_type
      threshold = sip.threshold
      
      search_db_arr = sip.search_db_arr
      searched_mod_arr = sip.searched_modification_arr
      psi_ms_terms = sip.psi_ms_terms
      user_params = sip.user_params
      
      search_db_arr.each do |sdb| 
        this_sdb = SearchDatabase.find_or_create_by_name_and_version_and_release_date_and_number_of_sequences_and_location
        (:name => sdb.name, :version => sdb.version, :release_date => sdb.releaseDate, :number_of_sequences => sdb.num_seq, :location => sdb.location)
        #Save one SIP per each (usually one) of its SDBs. Different SDBs mean completely new SIP (NEW SEARCHES) !!
        #SpectrumIdentificationProtocol.new(:sip_id => sip_id, :input_spectra => input_spectra,
        #:analysis_software => analysis_software, :search_type => search_type, :threshold => threshold,
        # :search_database_id => this_sdb.id).save
        SpectrumIdentificationProtocol.find_or_create_by_sip_id_and_input_spectra_and_analysis_software_and_search_type_and_threshold_and_search_database_id)
        (:sip_id => sip_id, :input_spectra => input_spectra,:analysis_software => analysis_software, :search_type => search_type, :threshold => threshold, :search_database_id => this_sdb.id)
        
      end
  
      
    end
  end


end
