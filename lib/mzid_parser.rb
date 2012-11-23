require 'nokogiri'

class Mzid

  attr_reader :mzid_file_id

  def initialize(mzid_file)

    @doc = Nokogiri::XML(File.open(mzid_file))
    @mzid_file_id = MzidFile.find_by_location(mzid_file).id
    #@doc = Nokogiri::XML(File.open("/home/vital/pepXML_protXML_2_mzid_V/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid"))

    #save_all_cv_terms

  end


  def spectrum_identifications
    si_arr = []
    @doc.xpath("//xmlns:SpectrumIdentification").each do |si|
      si_id = si.attr("id")
      sip_ref = si.attr("spectrumIdentificationProtocol_ref")
      sil_ref = si.attr("spectrumIdentificationList_ref")
      si_name ||= si.attr("name")
      activity_date ||= si.attr("activityDate")
      input_spectra_files_arr, search_db_arr = [] , [] #input_spectra_ref_arr es un arr de input_spectra hashes  #input_spectra = {} #[ {"SID_AtiO2" => "AtiO2.mzML"}, {"SID_Elu1A" => "Elu1A.mzML"}, {"SID_Elu2A" => "Elu2A.mzML"} ]
      si.xpath(".//xmlns:InputSpectra").each do |i_s|
        sd_id = i_s.attr("spectraData_ref")
        spectra_data = @doc.xpath("//xmlns:SpectraData[@id='#{sd_id}']") #input_spectra[sd_id] = spectra_data.attr("location").to_s.split("/")[-1]
        input_spectra_files_arr << spectra_data.attr("location").to_s.split("/")[-1]
      end      
      si.xpath(".//xmlns:SearchDatabaseRef").each do |sdb|
        sdb_id = sdb.attr("searchDatabase_ref")
        search_database = @doc.xpath("//xmlns:SearchDatabase[@id='#{sdb_id}']")[0]
        name = get_cvParam_and_or_userParam(search_database.xpath(".//xmlns:DatabaseName"))
        location, version = search_database.attr("location"), search_database.attr("version")
        releaseDate, num_seq = search_database.attr("releaseDate"),  search_database.attr("numDatabaseSequences")
        sdb = SearchDB.new(name, location, version, releaseDate, num_seq)
        search_db_arr << sdb if search_db_arr.empty?
        search_db_arr << sdb unless search_db_arr.include? sdb
      end      
      si_arr << Si.new(si_id, sip_ref, sil_ref, si_name, activity_date, input_spectra_files_arr, search_db_arr)
    end
    return si_arr
  end
  

  def sip(sip_ref)

    sip = @doc.xpath("//xmlns:SpectrumIdentificationProtocol[@id='#{sip_ref}']")[0]
    sip_id = sip_ref

    #<SearchType minOccurs:1 >
    search_type = get_cvParam_and_or_userParam(sip.xpath(".//xmlns:SearchType"))

    #<Threshold minOccurs:1 >
    threshold = get_cvParam_and_or_userParam(sip.xpath(".//xmlns:Threshold"))

    #<SpectrumIdentificationProtocol, attribute analysisSoftware_ref : required
    analysisSoftware_ref = sip.attr("analysisSoftware_ref")
    analysis_software_node = @doc.xpath("//xmlns:AnalysisSoftware[@id='#{analysisSoftware_ref}']")[0]
    software_name_node = analysis_software_node.xpath("./xmlns:SoftwareName")
    analysis_software = get_cvParam_and_or_userParam(software_name)

    #---- parent_tol_cv_terms & fragment_tol_cv_terms ----
    parent_tolerance_node = sip.xpath(".//xmlns:ParentTolerance")[0] #<ParentTolerance maxOccurs: 1>
    parent_tolerance = getcvParams(parent_tolerance_node) unless parent_tolerance_node.nil?
    fragment_tolerance_node = sip.xpath(".//xmlns:FragmentTolerance")[0]
    fragment_tolerance = getcvParams(fragment_tolerance_node) unless fragment_tolerance_node.nil?

    #<ModificationParams minOccurs: 0> <SearchModification minOccurs: 1>
    unless sip.xpath(".//xmlns:ModificationParams").empty?
      searched_modification_arr = []
      sip.xpath(".//xmlns:SearchModification").each do |search_mod|
        mass_d, fixed = search_mod.attr("massDelta"), search_mod.attr("fixedMod")
        residue = search_mod.attr("residues")
        unimod_ac = getcvParams(search_mod)[0][:accession] #<cvParam minOccurs:1>
        searched_modification_arr << SearchedMod.new(mass_d, fixed, residue, unimod_ac)
      end
    end

    #---- psi_ms_terms ---- ALL SIP children's cvParams go to sip_psi_ms_terms and sip_user_params
    nodes_w_cvP, cvP_parent_names = [], []
    sip.xpath(".//xmlns:cvParam").each do |cvP| # ".// means it searches in ALL nodes under current sip
      nodes_w_cvP << cvP.parent  unless cvP_parent_names.include? cvP.parent.name #but I want only the parent node of the <cvParam to use in getcvParam
      cvP_parent_names << cvP.parent.name
    end
    all_cvParams_per_sip = []
    nodes_w_cvP.each do |n|
      all_cvParams_per_sip << getcvParams(n)
    end
    all_cvParams_per_sip.flatten!
    psi_ms_terms = all_cvParams_per_sip.delete_if { |h| h[:cvRef] != "PSI-MS"}
    psi_ms_terms = all_cvParams_per_sip.delete_if { |h| h[:accession] =~ /MS:100141(2|3)/ } #tolerances already stored

    #---- user_params ----
    nodes_w_uP, uP_parent_names = [], []
    sip.xpath(".//xmlns:userParam").each do |uP|
      nodes_w_uP << uP.parent unless uP_parent_names.include? uP.parent.name
      uP_parent_names << uP.parent.name
    end
    user_params = []
    nodes_w_uP.each do |n|
      user_params << getuserParams(n)
    end
    user_params.flatten!
    
    sip_args_arr = [sip_id, search_type, threshold, analysis_software, searched_modification_arr, parent_tolerance, fragment_tolerance, psi_ms_terms, user_params]
    sip = Sip.new(sip_args_arr)

    return sip

  end


  def sil(sil_ref)
    sil = @doc.xpath("//xmlns:SpectrumIdentificationList[@id='#{sil_ref}']")[0]
    sil_id = sil.attr("id")
    num_seq_searched ||= sil.attr("numSequencesSearched")
    sil = Sil.new(:sil_id, :num_seq_searched)
    return sil
  end
  
  
  def spectrum_identification_results(sil_ref)
    results = []
    sil = @doc.xpath("//xmlns:SpectrumIdentificationList[@id='#{sil_ref}']")[0]
    sil.xpath(".//xmlns:SpectrumIdentificationResult").each do |sir|
      sir_id = sir.attr("id")
      spectrum_name = sir.attr("name")
      spectrum_id = sir.attr("spectrumID")
      sir_psi_ms_cv_terms = getcvParams(sir)
      sir_user_params = getuserParams(sir)      
      items_arr = []
      sir.xpath(".//xmlns:SpectrumIdentificationItem").each do |sii|
        sii_id = sii.attr("id")
        calc_m2z = sii.attr("calculatedMassToCharge")
        exp_m2z = sii.attr("experimentalMassToCharge")
        rank = sii.attr("rank")
        charge_state = sii.attr("chargeState")
        pass_threshold = sii.attr("passThreshold")
        pepEv_ref_arr = []
        sii.xpath("./xmlns:PeptideEvidenceRef").each do |pepEvRef|
          pepEv_ref_arr << pepEvRef.attr("peptideEvidence_ref")
        end
        sii_psi_ms_cv_terms = getcvParams(sii)
        sii_user_params = getuserParams(sii)
        items_arr << Sii.new(sii_id, calc_m2z, exp_m2z, rank, charge_state, pass_threshold, pepEv_ref_arr, sii_psi_ms_cv_terms, sii_user_params)
      end
      results << Sir.new(sir_id, spectrum_name, spectrum_id, sir_psi_ms_cv_terms, sir_user_params, items_arr)
      
    end
    
    return results
  
  end


end #class Mzid







  private

   #special method for retrieving these when <cvParam minOccurs:1 max:1> y <userParams minOccurs:1  max:1>
   #I can't figure out whether they are mutually exclusive or not
  def get_cvParam_and_or_userParam(node)
    name = ""
    if !getcvParams(node).empty?
      name = getcvParams(node)[0][:name]
    elsif !getuserParams(node).empty?
      name = name + " ; " + getuserParams(node)[0][:name] if name != ""
      name = getuserParams(node)[0][:name] if name == ""
    else
      #break
      puts "there must be at least cvParam and/or userParam under #{node.node_name}"
    end
  end


  def getcvParams(parent_node)
    cvParams = []
    parent_node.xpath("./xmlns:cvParam").each do |cvP| #("./xmlns: searches in current node ; (".//xmlns: searches in all children !!
      cv_hash = {:name => cvP.attr("name"), :accession => cvP.attr("accession"), :value => cvP.attr("value"), :cvRef => cvP.attr("cvRef"),
      :unitAccession => cvP.attr("unitAccession"), :unitCvRef => cvP.attr("unitCvRef"), :unitName => cvP.attr("unitName")}
      cvParams << cv_hash
    end
    return cvParams
  end


  def getuserParams(parent_node)
    userParams = []
    parent_node.xpath("./xmlns:userParam").each do |userP|
      user_hash = {:name => userP.attr("name"), :value => userP.attr("value")}
      userParams << user_hash
    end
    return userParams
  end



class Si

  attr_reader :si_id, :sip_ref, :sil_ref, :si_name, :activity_date, :input_spectra_files_arr, :search_db_arr

  def initialize(si_id, sip_ref, sil_ref, si_name, activity_date, input_spectra_files_arr, search_db_arr)
    @si_id = si_id
    @sip_ref = sip_ref
    @sil_ref = sil_ref
    @si_name = si_name
    @activity_date = activity_date
    @input_spectra_files_arr = input_spectra_files_arr
    @search_db_arr = search_db_arr
  end

end


Sil = Struct.new(:sil_id, :num_seq_searched)
SearchedMod = Struct.new(:mass_delta, :fixedMod, :residue, :unimod_accession)
SearchDB = Struct.new(:name, :location, :version, :releaseDate, :num_seq)

class Sip 

  attr_reader :sip_id, :search_type, :threshold, :analysis_software, :searched_modification_arr, :parent_tolerance, :fragment_tolerance, :psi_ms_terms, :user_params
  
  def initialize(args_arr)
     @sip_id = args_arr[0]
     @search_type = args_arr[1]
     @threshold = args_arr[2]
     @analysis_software = args_arr[3]
     @searched_modification_arr = args_arr[4]
     @parent_tolerance = args_arr[5]
     @fragment_tolerance = args_arr[6]
     @psi_ms_terms = args_arr[7]
     @user_params = args_arr[8]
  end
end


class Sir

  attr_reader :sir_id, :spectrum_id, :spectrum_name, :sir_psi_ms_cv_terms, :sir_user_params, :items_arr
  
  def initialize(sir_id, spectrum_id, spectrum_name, sir_psi_ms_cv_terms, sir_user_params, items_arr)
    @sir_id = sir_id
    @spectrum_id = spectrum_id
    @spectrum_name = spectrum_name
    @sir_psi_ms_cv_terms = sir_psi_ms_cv_terms
    @sir_user_params = sir_user_params
    @items_arr = items_arr  
  end

end


class Sii

  attr_reader :sii_id, :calc_m2z, :exp_m2z, :rank, :charge_state, :pass_threshold, :pepEv_ref_arr, :sii_psi_ms_cv_terms, :sii_user_params
  
  def initialize(sii_id, calc_m2z, exp_m2z, rank, charge_state, pass_threshold, pepEv_ref_arr, sii_psi_ms_cv_terms, sii_user_params)
    @sii_id = sii_id
    @calc_m2z = calc_m2z
    @exp_m2z = exp_m2z
    @rank = rank
    @charge_state = charge_state
    @pass_threshold = pass_threshold 
    @pepEv_ref_arr = pepEv_ref_arr
    @sii_psi_ms_cv_terms = sii_psi_ms_cv_terms
    @sii_user_params = sii_user_params
  end

end


