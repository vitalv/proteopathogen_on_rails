class Mzid2db

  def initialize(mzid_object)
    @mzid_obj = mzid_object
    @mzid_file_id = mzid_object.mzid_file_id
  end


  ##ATENÇAO!! Sería interesante hacer una funcion experiment_rollback que borre el ultimo experimento que he metido con todos los datos de todas las tablas (no se borrara nada en las de SIP-scope que tengan otros SIP asociados)!!
  #La idea es que una vez que se empieza a insertar datos (un experimento/busqueda) se llenen TOODAS las tablas y que no se quede a medias. Y si no se completa el proceso hacer un rollback automatico
  #ENtonces tendría que controlar que no se vuelve a insertar el mismo experimento para
  #usar  find_or_create SOLO en aquellas tablas con Global-scope  (que pueden tener records iguales en distintos SIP:experimentos/busquedas) como search_databases o peptides, etc..


  def save2tables

    spectrum_identification_lists_ids = []
    
    @mzid_obj.spectrum_identifications.each do |si|
    
      mzid_si_id = si.si_id
      this_si = SpectrumIdentification.create(:si_id => mzid_si_id, :name => si.si_name, :activity_date => si.activity_date)

      #--- save 2 sar_si_join_table. si.spectra_acquisition_runs
      si.input_spectra_files_arr.each do |s_f|
        this_si.spectra_acquisition_runs << SpectraAcquisitionRun.find_by_spectra_file(s_f)
      end
      
      #--- get si.sip and sip attributes and sip-related tables ---
      sip = @mzid_obj.sip(si.sip_ref)
      si_id = this_si.id
      sip_id = sip.sip_id
      analysis_software = sip.analysis_software
      search_type = sip.search_type
      threshold = sip.threshold
      searched_mod_arr = sip.searched_modification_arr
      parent_tol_plus_value, parent_tol_minus_value = sip.parent_tolerance[0][:value], sip.parent_tolerance[1][:value]
      fragment_tol_plus_value, fragment_tol_minus_value = sip.fragment_tolerance[0][:value], sip.fragment_tolerance[1][:value]
      psi_ms_terms = sip.psi_ms_terms
      user_params = sip.user_params
      #--- save si.sip
      this_sip = SpectrumIdentificationProtocol.create(:spectrum_identification_id => si_id, :sip_id => sip_id, :analysis_software => analysis_software, :search_type => search_type, :threshold => threshold, :parent_tol_plus_value => parent_tol_plus_value, :parent_tol_minus_value => parent_tol_minus_value, :fragment_tol_plus_value => fragment_tol_plus_value, :fragment_tol_minus_value => fragment_tol_minus_value)      
      #---- save sip_psi_ms_cv_terms ---- sip_psi_ms_cv_term es SIP-scope ??
      unless psi_ms_terms.empty?
        psi_ms_terms.each do |psi_ms_term|
          this_psi_term = SipPsiMsCvTerm.find_or_initialize_by_spectrum_identification_protocol_id_and_psi_ms_cv_term_accession(:spectrum_identification_protocol_id => this_sip.id, :psi_ms_cv_term_accession => psi_ms_term[:accession])
          this_psi_term.value = psi_ms_term[:value] if this_psi_term.new_record? unless psi_ms_term[:value].blank?
          this_psi_term.save
        end
      end
      #---- save sip_user_params ----
      unless user_params.empty?
        user_params.each do |userP|
          this_userP = SipUserParam.find_or_initialize_by_spectrum_identification_protocol_id_and_name(:spectrum_identification_protocol_id => this_sip.id, :name => userP[:name])
          this_userP.value = userP[:value] if this_userP.new_record? unless userP[:value].blank?
          this_userP.save
        end
      end
      #---- save sip.searched_modifications ---- Global-scope
      unless searched_mod_arr.empty?
        searched_mod_arr.each do |mod|
          #Y ademas estoy insertando records que ya existian! Entonces pa que coño quiero la join table !!
          #is_fixed boolean 'true' is saved as 1 in mysql -tinyint(1)-, so watch the fuck out
          fixed = '1' if mod.fixedMod == 'true'; fixed = '0' if mod.fixedMod == 'false'
          this_mod = SearchedModification.find_or_create_by_unimod_accession_and_mass_delta_and_residue_and_is_fixed(:unimod_accession => mod.unimod_accession, :mass_delta => mod.mass_delta, :residue => mod.residue, :is_fixed => fixed)
          this_sip.searched_modifications << this_mod unless this_sip.searched_modifications.include? this_mod
        end
      end
      
      #--- save si.search_databases ---
      si.search_db_arr.each do |sdb|
        this_sdb = SearchDatabase.find_or_create_by_name_and_version_and_release_date_and_number_of_sequences_and_location(:name => sdb.name, :version => sdb.version, :release_date => sdb.releaseDate, :number_of_sequences => sdb.num_seq, :location => sdb.location)
        #Aqui SÍ debo usar find_or_create porque es Global-scope. De hecho muchas veces irá a la parte "find"
        this_si.search_databases << this_sdb unless this_si.search_databases.include? this_sdb
      end

      #--- save si.sil ---
      sil = @mzid_obj.sil(si.sil_ref)
      sil_id = sil.sil_id
      num_seq_searched = sil.num_seq_searched
      
      this_sil = SpectrumIdentificationList.create(:sil_id => sil_id, :spectrum_identification_id => si_id, :num_seq_searched => num_seq_searched)
      spectrum_identification_lists_ids << this_sil.id
      
    end #@mzid_obj.spectrum_identifications.each do |si|




    spectrum_identification_lists_ids.each do |sil_id|
      sil_ref = sil_id.sil_id
      results_arr = @mzid_obj.spectrum_identification_results(sil_ref)
      results.each do |sir|
        sir_id = sir.sir_id
        spectrum_identification_list_id = sil_id
        spectrum_id = sir.spectrum_id
        spectrum_name = sir.spectrum_name
        sir_psi_ms_cv_terms = sir.sir_psi_ms_cv_terms
        sir_user_params = sir.sir_user_params
        items_arr = sir.items_arr
        this_sir = SpectrumIdentificationResult.create(:sir_id => sir_id, :spectrum_identification_list_id => sil_id, :spectrum_id => spectrum_id, :spectrum_name => spectrum_name)
        unless sir_psi_ms_cv_terms.empty?
          sir_psi_ms_cv_terms.each do |psi_ms_t|
            SirPsiMsCvTerm.find_or_initialize_by_spectrum_identification_result_id()
#SipPsiMsCvTerm.find_or_initialize_by_spectrum_identification_protocol_id_and_psi_ms_cv_term_accession(:spectrum_identification_protocol_id => this_sip.id, :psi_ms_cv_term_accession => psi_ms_term[:accession])                        
          end
        end
      end
    
    end
   

  end # def save2tables




end


  def rollback(mzid_file_id)
    if MzidFile.exists? mzid_file_id
      #puts "\n-Error saving data 2 tables. Rolling back -- \n\n"
      MzidFile.find(mzid_file_id).spectra_acquisition_runs.each do |sar|
        sar.spectrum_identifications.each do |si|
          sip_id = si.spectrum_identification_protocol
          SpectrumIdentificationProtocol.destroy(sip_id)
          SpectrumIdentification.destroy(si.id)
        end
        #SpectraAcquisitionRun.destroy(sar.id)
      end
      #MzidFile.destroy(mzid_file_id)

    end

  end

