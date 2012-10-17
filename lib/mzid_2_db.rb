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
      
      #---- SAVE 2 spectrum_identification_protocols ----
      this_sip = SpectrumIdentificationProtocol.find_or_create_by_sip_id_and_input_spectra_and_analysis_software_and_search_type_and_threshold(:sip_id => sip_id, :input_spectra => input_spectra, :analysis_software => analysis_software, :search_type => search_type, :threshold => threshold)
      
      #---- SAVE 2 search_databases AND sip_sdb_join_table ----   ##STILL HAVE 2 CREATE INDEX IN JOIN TABLE##
      search_db_arr.each do |sdb|
        this_sdb = SearchDatabase.find_or_create_by_name_and_version_and_release_date_and_number_of_sequences_and_location(:name => sdb.name, :version => sdb.version, :release_date => sdb.releaseDate, :number_of_sequences => sdb.num_seq, :location => sdb.location)
        this_sip.search_databases << this_sdb unless this_sip.search_databases.include? this_sdb
      end
      
      #---- SAVE 2 sip_psi_ms_cv_terms ----
      psi_ms_terms.each do |psi_ms_term|
        this_psi_term = SipPsiMsCvTerm.find_or_initialize_by_spectrum_identification_protocol_id_and_accession(:spectrum_identification_protocol_id => sip_id, :accession => psi_ms_term[:accession])
        SipPsiMsCvTerm.value = psi_ms_term[:value] if this_psi_term.new_record?
      end
   
    end
  end


end
