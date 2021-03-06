require 'nokogiri'

#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid")
#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/CandidaRotofor-1.pep.mzid")
#@doc = Nokogiri::XML(File.open("/home/vital/pepXML_protXML_2_mzid_V/examplefile.mzid"))
#@pdl = Nokogiri::XML(File.open("/home/vital/proteopathogen_on_rails/public/uploaded_mzid_files/Orbitrap_XL_CID_SILAC_IMAC_Replicate_1B.mzid")).xpath("//xmlns:ProteinDetectionList[@id='PDL_1']")[0]

class Mzid

  attr_reader :mzid_file_id

  def initialize(mzid_file)

    @doc = Nokogiri::XML(File.open(mzid_file))
    @mzid_file_id ||= MzidFile.find_by_location(mzid_file).id
    @psi_ms_cv_terms = psi_ms_cv_terms
    @unimod_cv_terms = unimod_cv_terms

  end



  def psi_ms_cv_terms
    psi_t = {}
    accessions = []
    @doc.xpath("//xmlns:cvParam[@cvRef='PSI-MS' or @cvRef='MS']").each do |psiterm|
      ac = psiterm.attr("accession")
      name = psiterm.attr("name")
      psi_t[ac] = name unless accessions.include? ac
      accessions << ac
    end
    return psi_t
  end


  def unimod_cv_terms
    unimod_t = {}
    accessions = []
    @doc.xpath("//xmlns:cvParam[@cvRef='UNIMOD']").each do |uniterm|
      ac = uniterm.attr("accession")
      name = uniterm.attr("name")
      unimod_t[ac] = name unless accessions.include? ac
      accessions << ac
    end
    return unimod_t
  end



#<SequenceCollection> ------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------

  def pep(pep_ref)
    pep = @doc.xpath("//xmlns:Peptide[@id='#{pep_ref}']")[0]
    sequence = pep.xpath("./xmlns:PeptideSequence").text
    pep_id = pep.attr("id")
    modif_arr = [] #Array de Structs PeptideMod (que a su vez es un attr del objeto de la clase
    pep.xpath(".//xmlns:Modification").each do |mod| #:unimod_acc
      residue = mod.attr("residues")
      avg_mass_delta = mod.attr("avgMassDelta")
      location = mod.attr("location")
      cv_params = getcvParams(mod)
      modif_arr << PeptideMod.new(residue, avg_mass_delta, location, cv_params)
    end
    Pep.new(sequence, modif_arr)
  end


  def pep_evidence(pepEv_ref)
    pepEv = @doc.xpath("//xmlns:PeptideEvidence[@id='#{pepEv_ref}']")[0] #There is only ONE peptideEvidence per id, so it's ok I get [0]
    pepEv_id = pepEv.attr("id")
    name = pepEv.attr("name")
    start_pos, end_pos = pepEv.attr("start"), pepEv.attr("end")
    pre, post = pepEv.attr("pre"), pepEv.attr("post")
    is_decoy, name = pepEv.attr("isDecoy"), pepEv.attr("name")
    db_seq_ref, pep_ref = pepEv.attr("dBSequence_ref"), pepEv.attr("peptide_ref")
    pep_ev = PepEv.new(pepEv_id, start_pos, end_pos, pre, post, is_decoy, db_seq_ref, name, pep_ref)#PepEv = Struct.new(:pepEv_id, :start, :end, :pre, :post, :is_decoy, :db_seq_ref, :name, :pep_ref)
    return pep_ev
  end


  def db_seq(dbseq_ref)
    dBSeq = @doc.xpath("//xmlns:DBSequence[@id='#{dbseq_ref}']")[0]
    db_seq_id = dBSeq.attr("id")
    search_db_ref = dBSeq.attr("searchDatabase_ref")
    accession = dBSeq.attr("accession")
    sequence = dBSeq.xpath("./xmlns:Seq").text
    description = nil
    getcvParams(dBSeq).each { |cvP|  description = cvP[:value] if cvP[:accession] == "MS:1001088" }
    db_seq = DBSeq.new(db_seq_id, search_db_ref, accession, sequence, description) #DBSeq = Struct.new(:id, :search_db_ref, :accession, :sequence, :description)
    return db_seq
  end


#<AnalysisCollection> ------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------

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
        if search_database.attr("location") == "" or search_database.attr("location").nil? #model has a validation, location is required, but there might be some bad mzid files with attribute location: ""
          location = "unkown/location" 
        end
        releaseDate, num_seq = search_database.attr("releaseDate"),  search_database.attr("numDatabaseSequences")
        sdb = SearchDB.new(name, sdb_id, location, version, releaseDate, num_seq)
        search_db_arr << sdb if search_db_arr.empty?
        search_db_arr << sdb unless search_db_arr.include? sdb
      end
      si_arr << Si.new(si_id, sip_ref, sil_ref, si_name, activity_date, input_spectra_files_arr, search_db_arr)
    end
    return si_arr
  end


  def protein_detection #max_occurs = 1
    if pd = @doc.xpath("//xmlns:ProteinDetection")[0]
      pd_id = pd.attr("id")
      pd_name = pd.attr("name")
      pdp_ref = pd.attr("proteinDetectionProtocol_ref")
      pdl_ref = pd.attr("proteinDetectionList_ref")
      sil_ref_arr = []
      pd.xpath(".//xmlns:InputSpectrumIdentifications").each do |sil_ref|
        sil_ref_arr << sil_ref.attr("spectrumIdentificationList_ref")
      end
      return ProtDetection.new(pd_id, pd_name, pdp_ref, pdl_ref, sil_ref_arr)
    end
  end



#<AnalysisProtocolCollection> ------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------

  def sip(sip_ref) #<SpectrumIdentificationProtcol> minOccurs:1; maxOccurs: unbounded
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
    analysis_software = get_cvParam_and_or_userParam(software_name_node)
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
    psi_ms_terms = all_cvParams_per_sip.delete_if { |h| h[:cvRef] != "PSI-MS"} #i.e. cvRef == "UNIMOD"
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


  def pdp(pdp_ref)  #<ProteinDetectionProtocol> minOccurs:0; maxOccurs: 1
    #<AnalysisParams>  #minOccurs:0; maxOccurs: 1
    #<Threshold>  #minOccurs:1; maxOccurs: 1
    pdp = @doc.xpath("//xmlns:ProteinDetectionProtocol[@id='#{pdp_ref}']")[0]
    pdp_id = pdp_ref
    analysis_software = pdp.attr("analysisSoftware_ref")
    pdp_name = pdp.attr("name")
    thr = pdp.xpath(".//xmlns:Threshold")
    analysis_params = pdp.xpath(".//xmlns:AnalysisParams")
    psi_ms_terms = getcvParams(thr) + getcvParams(analysis_params)
    user_params = getuserParams(thr) + getuserParams(analysis_params)
    return Pdp.new(pdp_id, analysis_software, pdp_name, psi_ms_terms, user_params)
  end


#<DataCollection><AnalysisData> ------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------

  def sil(sil_ref)
    sil = @doc.xpath("//xmlns:SpectrumIdentificationList[@id='#{sil_ref}']")[0]
    sil_id = sil.attr("id")
    num_seq_searched ||= sil.attr("numSequencesSearched")
    sil = Sil.new(sil_id, num_seq_searched)
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
        fragments_arr = [] #Array de Fragments
        if fragmentation = sii.xpath("./xmlns:Fragmentation")[0] #maxOccurs = 1
          fragmentation.xpath("./xmlns:IonType").each do |ion|
            mz_values_arr, m_intensity_arr, m_err_arr = [], [], []
            if !ion.xpath("./xmlns:FragmentArray").empty? #minOccurs = 0
              ion.xpath("./xmlns:FragmentArray").each do |frg_arr|              
                measure_ref = frg_arr.attr("measure_ref")
                measure_name = sil.xpath(".//xmlns:Measure[@id='#{measure_ref}']").xpath("./xmlns:cvParam").attr("name").value                
                mz_values_arr = frg_arr.attr("values").split("\s") if measure_name == "product ion m/z"
                m_intensity_arr = frg_arr.attr("values").split("\s") if measure_name == "product ion intensity"
                m_err_arr = frg_arr.attr("values").split("\s") if measure_name == "product ion m/z error"
              end
            end
            fragment_name = getcvParams(ion)[0][:name]
            fragment_psi_ms_cv_acc = getcvParams(ion)[0][:accession]
            charge = ion.attr("charge")
            ion_index_arr = ion.attr("index").to_s.split("\s")
            ion_index_arr.each_with_index do |ion_index, i| #por cada uno de estos creo lo que yo llamo un Fragment (modelo)
              mz_value = mz_values_arr[i] unless mz_values_arr.empty?
              m_intensity = m_intensity_arr[i] unless m_intensity_arr.empty?
              m_err = m_err_arr[i] unless m_err_arr.empty?
              fragments_arr << FragmentIon.new(ion_index, fragment_name, fragment_psi_ms_cv_acc, charge, mz_value, m_intensity, m_err )
            end
          end
        end
        sii_psi_ms_cv_terms = getcvParams(sii)
        sii_user_params = getuserParams(sii)
        items_arr << Sii.new(sii_id, calc_m2z, exp_m2z, rank, charge_state, pass_threshold, pepEv_ref_arr, sii_psi_ms_cv_terms, sii_user_params, fragments_arr)
      end
      results << Sir.new(sir_id, spectrum_name, spectrum_id, sir_psi_ms_cv_terms, sir_user_params, items_arr)
    end
    return results #Array of Result objects (that will be related to one sil)
  end


  def pdl(pdl_ref)
    #no necesito un metodo para esto, bueno podría coger el name
  end


 def protein_ambigroups(pdl_ref)
   pag_arr = []
   pdl = @doc.xpath("//xmlns:ProteinDetectionList[@id='#{pdl_ref}']")[0]
   pdl.xpath("//xmlns:ProteinAmbiguityGroup").each do |pag|
     protein_hypothesis_arr = []
     pag_id = pag.attr("id")
     pag.xpath(".//xmlns:ProteinDetectionHypothesis").each do |prot_hyp|
       pass_thr = prot_hyp.attr("passThreshold")
       name ||= prot_hyp.attr("name")
       prot_hyp_id = prot_hyp.attr("id")
       pep_hyp_arr = []
       prot_hyp.xpath(".//xmlns:PeptideHypothesis").each do |pep_hyp|
         pepEv_ref = pep_hyp.attr("peptideEvidence_ref")
         pepEv_ref_sii_arr = []
         pep_hyp.xpath(".//xmlns:SpectrumIdentificationItemRef").each do |sii_ref|
           pepEv_ref_sii_arr << sii_ref.attr("spectrumIdentificationItem_ref")
         end
         pep_hyp_arr << PepHyp.new(pepEv_ref, pepEv_ref_sii_arr)
       end
       prot_hyp_psi_ms_cv_terms = getcvParams(prot_hyp)
       prot_hyp_user_params = getuserParams(prot_hyp)
       protein_hypothesis_arr << ProtHyp.new(pass_thr, name, prot_hyp_id, pep_hyp_arr, prot_hyp_psi_ms_cv_terms, prot_hyp_user_params )
     end
     pag_arr << Pag.new(pag_id, protein_hypothesis_arr)
   end
   return pag_arr
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
      name = name + " ; " + getuserParams(node)[0][:value] if getuserParams(node)[0][:name] == "name" and name != ""
      name = getuserParams(node)[0][:name] if name == ""
      name = getuserParams(node)[0][:value] if name == "name" #getuserParams(node)[0][:name] == "name" and name == ""
    else
      #break
      puts node.class
      puts node.inspect
      #puts "there must be at least cvParam and/or userParam under #{node.node_name}"
    end
    return name
  end


  def getcvParams(parent_node)
    cvParams = []
    parent_node.xpath("./xmlns:cvParam").each do |cvP| #("./xmlns: searches in current node ; (".//xmlns: searches in all children !!
      cv_hash = {:name => cvP.attr("name"), :accession => cvP.attr("accession"), :value => cvP.attr("value"), :cvRef => cvP.attr("cvRef"),
      :unitAccession => cvP.attr("unitAccession"), :unitCvRef => cvP.attr("unitCvRef"), :unitName => cvP.attr("unitName")}
      cv_hash.map { |k,v| cv_hash[k] = nil if v == "" }
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


DBSeq = Struct.new(:id, :search_db_ref, :accession, :sequence, :description)
PepEv = Struct.new(:pepEv_id, :start, :end, :pre, :post, :is_decoy, :db_seq_ref, :name, :pep_ref)
PeptideMod = Struct.new(:residue, :avg_mass_delta, :location, :cv_params)


class Pep
  attr_reader :sequence, :modif_arr #, :pep_id
  def initialize(sequence, modif_arr)
    @sequence = sequence
    @modif_arr = modif_arr
  end
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
SearchDB = Struct.new(:name, :sdb_id, :location, :version, :releaseDate, :num_seq)


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
  attr_reader :sir_id, :spectrum_name, :spectrum_id, :sir_psi_ms_cv_terms, :sir_user_params, :items_arr
  def initialize(sir_id, spectrum_name, spectrum_id, sir_psi_ms_cv_terms, sir_user_params, items_arr)
    @sir_id = sir_id
    @spectrum_id = spectrum_id
    @spectrum_name = spectrum_name
    @sir_psi_ms_cv_terms = sir_psi_ms_cv_terms
    @sir_user_params = sir_user_params
    @items_arr = items_arr
  end
end


FragmentIon = Struct.new(:ion_index, :fragment_name, :fragment_psi_ms_cv_acc, :charge, :mz_value, :m_intensity, :m_err )

class Sii
  attr_reader :sii_id, :calc_m2z, :exp_m2z, :rank, :charge_state, :pass_threshold, :pepEv_ref_arr, :sii_psi_ms_cv_terms, :sii_user_params, :fragments_arr
  def initialize(sii_id, calc_m2z, exp_m2z, rank, charge_state, pass_threshold, pepEv_ref_arr, sii_psi_ms_cv_terms, sii_user_params, fragments_arr)
    @sii_id = sii_id
    @calc_m2z = calc_m2z
    @exp_m2z = exp_m2z
    @rank = rank
    @charge_state = charge_state
    @pass_threshold = pass_threshold
    @pepEv_ref_arr = pepEv_ref_arr
    @sii_psi_ms_cv_terms = sii_psi_ms_cv_terms
    @sii_user_params = sii_user_params
    @fragments_arr = fragments_arr
  end
end


class Pag
  attr_reader :pag_id, :prot_hyp_arr
  def initialize(pag_id, prot_hyp_arr)
    @pag_id = pag_id
    @prot_hyp_arr = prot_hyp_arr
  end
end


class ProtHyp
  attr_reader :pass_thr, :name, :prot_hyp_id, :pep_hyp_arr, :prot_hyp_psi_ms_cv_terms, :prot_hyp_user_params
  def initialize(pass_thr, name, prot_hyp_id, pep_hyp_arr, prot_hyp_psi_ms_cv_terms, prot_hyp_user_params)
    @pass_thr = pass_thr
    @name = name
    @prot_hyp_id = prot_hyp_id
    @pep_hyp_arr = pep_hyp_arr
    @prot_hyp_psi_ms_cv_terms = prot_hyp_psi_ms_cv_terms
    @prot_hyp_user_params = prot_hyp_user_params
  end
end


class PepHyp
  attr_reader :pep_ev_ref, :sii_arr
  def initialize(pepEv_ref, pepEv_ref_sii_arr)
     @pep_ev_ref = pepEv_ref
     @sii_arr = pepEv_ref_sii_arr
  end
end


class ProtDetection
  attr_reader :pd_id, :pd_name, :pdp_ref, :pdl_ref, :sil_ref_arr
  def initialize(pd_id, pd_name, pdp_ref, pdl_ref, sil_ref_arr)
    @pd_id = pd_id
    @pd_name = pd_name
    @pdp_ref = pdp_ref
    @pdl_ref = pdl_ref
    @sil_ref_arr = sil_ref_arr
  end
end


class Pdp
  attr_reader :pdp_id, :analysis_software, :pdp_name, :psi_ms_terms, :user_params
  def initialize(pdp_id, analysis_software, pdp_name, psi_ms_terms, user_params)
    @pdp_id = pdp_id
    @analysis_software = analysis_software
    @pdp_name = pdp_name
    @psi_ms_terms = psi_ms_terms
    @user_params = user_params
  end
end


class Pdl



end



