class Mzid2db

  def initialize(mzid_object)
    @mzid_obj = mzid_object
  end


  ##ATENÇAO!! Sería interesante hacer una funcion experiment_rollback que borre el ultimo experimento que he metido con todos los datos de todas las tablas (no se borrara nada en las de SIP-scope que tengan otros SIP asociados)!!
  #La idea es que una vez que se empieza a insertar datos (un experimento/busqueda) se llenen TOODAS las tablas y que no se quede a medias. Y si no se completa el proceso hacer un rollback automatico
  #ENtonces tendría que controlar que no se vuelve a insertar el mismo experimento para
  #usar  find_or_create SOLO en aquellas tablas con Global-scope  (que pueden tener records iguales en distintos SIP:experimentos/busquedas) como search_databases o peptides, etc..
  @@saved_sip_ids


  def save2tables

    saved_sip_ids = []
    @mzid_obj.sips.each do |sip|
    
      sip_id = sip.sip_id
      input_spectra = sip.input_spectra
      analysis_software = sip.analysis_software
      search_type = sip.search_type
      threshold = sip.threshold      
      search_db_arr = sip.search_db_arr
      searched_mod_arr = sip.searched_modification_arr
      psi_ms_terms = sip.psi_ms_terms
      parent_tol_plus_value, parent_tol_minus_value = sip.parent_tolerance[0][:value], sip.parent_tolerance[1][:value]
      fragment_tol_plus_value, fragment_tol_minus_value = sip.fragment_tolerance[0][:value], sip.fragment_tolerance[1][:value]
      user_params = sip.user_params
      
      #---- SAVE 2 spectrum_identification_protocols ----
      #this_sip = SpectrumIdentificationProtocol.find_or_create_by_sip_id_and_input_spectra_and_analysis_software_and_search_type_and_threshold(:sip_id => sip_id, :input_spectra => input_spectra, :analysis_software => analysis_software, :search_type => search_type, :threshold => threshold)
      this_sip = SpectrumIdentificationProtocol.create(:sip_id => sip_id, :input_spectra => input_spectra, :analysis_software => analysis_software, :search_type => search_type, :threshold => threshold, :parent_tol_plus_value => parent_tol_plus_value, :parent_tol_minus_value => parent_tol_minus_value, :fragment_tol_plus_value => fragment_tol_plus_value, :fragment_tol_minus_value => fragment_tol_minus_value)
      saved_sip_ids << this_sip.id
      #this_sip.create . Always . Don't have to check whether record exists bc even if all this_sip columns/attributes are found in a previous record, this_sip may be a completely new experiment (for instance repeating the search with a new DB)
      #well you could check just one thing: mzid file is the same and sip_id is the same, then DO check record exists and don't insert if true
      
      #---- SAVE 2 search_databases AND sip_sdb_join_table ----   ##STILL HAVE 2 CREATE INDEX IN JOIN TABLE##
      search_db_arr.each do |sdb|
        this_sdb = SearchDatabase.find_gr_create_by_name_and_version_and_release_date_and_number_of_sequences_and_location(:name => sdb.name, :version => sdb.version, :release_date => sdb.releaseDate, :number_of_sequences => sdb.num_seq, :location => sdb.location)
        #Aqui SÍ debo usar find_or_create porque es Global-scope. De hecho muchas veces irá a la parte "find"
        this_sip.search_databases << this_sdb unless this_sip.search_databases.include? this_sdb
      end
      
      #---- SAVE 2 sip_psi_ms_cv_terms ---- sip_psi_ms_cv_term es SIP-scope ??
      psi_ms_terms.each do |psi_ms_term|
        this_psi_term = SipPsiMsCvTerm.find_or_initialize_by_spectrum_identification_protocol_id_and_psi_ms_cv_term_accession(:spectrum_identification_protocol_id => this_sip.id, :psi_ms_cv_term_accession => psi_ms_term[:accession])
        this_psi_term.value = psi_ms_term[:value] if this_psi_term.new_record? unless psi_ms_term[:value].blank?
        this_psi_term.save        
      end
      
      #---- SAVE 2 sip_user_params ----
      user_params.each do |userP|
        this_userP = SipUserParam.find_or_initialize_by_spectrum_identification_protocol_id_and_name(:spectrum_identification_protocol_id => this_sip.id, :name => userP[:name])
        this_userP.value = userP[:value] if this_userP.new_record? unless userP[:value].blank?
        this_userP.save
      end
      
      #---- SAVE 2 searched_modifications ---- Global-scope
      searched_mod_arr.each do |mod|
        #Y ademas estoy insertando records que ya existian! Entonces pa que coño quiero la join table !!
        #is_fixed boolean 'true' is saved as 1 in mysql -tinyint(1)-, so watch the fuck out
        fixed = '1' if mod.fixedMod == 'true'; fixed = '0' if mod.fixedMod == 'false'
        this_mod = SearchedModification.find_or_create_by_unimod_accession_and_mass_delta_and_residue_and_is_fixed(:unimod_accession => mod.unimod_accession, :mass_delta => mod.mass_delta, :residue => mod.residue, :is_fixed => fixed)
        this_sip.searched_modifications << this_mod unless this_sip.searched_modifications.include? this_mod
      end
      
   
    end # @mzid_obj.sips.each do |sip|
    
    puts "saved_sip_ids: #{saved_sip_ids}"
    
    return saved_sip_ids #ESTO NO se returna si el error que rescato al llamar a save2tables ha ocurrido antes!!
    
  end # def save2tables




  def rollback(saved_sip_ids)
    puts "\n-Error saving data 2 tables. Rolling back -- \n\n"
    
    SpectrumIdentificationProtocol.destroy(saved_sip_ids)
    
    
#    unless SpectrumIdentificationProtocol.find(:all).empty?
#		mzid_object.sips.each do |sip|
#        db_sip_id = SpectrumIdentificationProtocol.find_by_sip_id(sip.sip_id)
#        SpectrumIdentificationProtocol.destroy(db_sip_id)
#      end   
#   end
   
  end


end


