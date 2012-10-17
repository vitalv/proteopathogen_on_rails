require 'nokogiri'

class Mzid

  def initialize(mzid_file)

    @doc = Nokogiri::XML(File.open(mzid_file))
    #@doc = Nokogiri::XML(File.open("/home/vital/pepXML_protXML_2_mzid_V/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid"))
    
    #save_all_cv_terms
  
  end
  
  
  
  def sips
    sips = []
    #<AnalysisProtocolCollection minOccurs: 1> -> <SpectrumIdentificationProtocol minOccurs:1 max:unbounded>
    @doc.xpath("//xmlns:SpectrumIdentificationProtocol").each do |sip|
      
      #---- sip_id ----
      sip_id = sip.attr("id")
      
      #---- search_type ----
      #<SearchType minOccurs:1 >
      this_search_type_node = sip.xpath(".//xmlns:SearchType")
      search_type = get_cvParam_and_or_userParam(this_search_type_node)
      
      #---- threshold ----
      #<Threshold minOccurs:1 >
      thr = sip.xpath(".//xmlns:Threshold")
      threshold = get_cvParam_and_or_userParam(thr)
      
      #---- analyisis_software ----
      analysisSoftware_ref, analysis_software = sip.attr("analysisSoftware_ref"), ""
      @doc.xpath("//xmlns:AnalysisSoftware").each do |soft|
        if soft.attr("id") == analysisSoftware_ref
          software_name_node = soft.xpath(".//xmlns:SoftwareName")
          analysis_software = get_cvParam_and_or_userParam(software_name_node)
        end
      end      
      
      #---- input_spectra ----
      input_spectra, spectraData_ref, searchDb_ref = "" , "", ""
      #<AnalysisCollection minOccurs:1> | <SpectrumIdentification minOccurs:1 max:unbounded>
      #Para obtener input_spectra tengo que buscar en 2 sitios:
      #1º Con mi sip_id busco en <SpectrumIdentification> para obtener spectraData_ref y searchDb_ref
      @doc.xpath("//xmlns:SpectrumIdentification").each do |si|
        if si.attr("spectrumIdentificationProtocol_ref") == sip_id #spectrumIdentificationProtocol_ref : required
          spectraData_ref = si.xpath(".//xmlns:InputSpectra/@spectraData_ref").to_s
          searchDb_ref = si.xpath(".//xmlns:SearchDatabaseRef/@searchDatabase_ref").to_s
        end
      end 
      #2º Una vez obtenido el spectraData_ref puedo buscar en <SpectraData>
      @doc.xpath("//xmlns:SpectraData").each do |spectra_data| #<DataCollection> : <Inputs> : <SpectraData>
        if spectra_data.attr("id") == spectraData_ref
          input_spectra = spectra_data.attr("location")
        end
      end
      
      #---- search_db_things ----
      #<SearchDatabase minOccurs: 0, maxOccurs: unbounded>
      search_db_arr = []
      if !@doc.xpath("//xmlns:SearchDatabase").empty?
        @doc.xpath("//xmlns:SearchDatabase").each do |db|
          if db.attr("id") == searchDb_ref
            name = get_cvParam_and_or_userParam(db.xpath(".//xmlns:DatabaseName"))
            location,    version = db.attr("location"),     db.attr("version")
            releaseDate, num_seq = db.attr("releaseDate"),  db.attr("numDatabaseSequences")
            sdb = SearchDB.new(name, location, version, releaseDate, num_seq)
            search_db_arr << sdb if search_db_arr.empty?
            search_db_arr << sdb unless search_db_arr.include? sdb
          end
        end
      end
      
      #---- searched_modifications -----
      #<ModificationParams minOccurs: 0> <SearchModification minOccurs: 1>
      if !sip.xpath(".//xmlns:ModificationParams").empty?
        searched_modification_arr = []
        sip.xpath(".//xmlns:SearchModification").each do |search_mod|
          mass_d, fixed = search_mod.attr("massDelta"), search_mod.attr("fixedMod")
          residue = search_mod.attr("residues")
          unimod_ac = getcvParams(search_mod)[0][:accession] #<cvParam minOccurs:1>
          searched_modification_arr << SearchedModification.new(mass_d, fixed, residue, unimod_ac)        
        end      
      end
      
      #---- psi_ms_terms ----
      all_cvParams_per_sip = getcvParams(sip)
      psi_ms_terms = all_cvParams_per_sip.delete_if { |h| h[:cvRef] != "PSI-MS" }
      
      #---- user_params ----
      user_params = getuserParams(sip)
      
      
      sips << Sip.new(sip_id, search_type, threshold, analysis_software, input_spectra, search_db_arr, searched_modification_arr,
                      psi_ms_terms, user_params)      

    end #@doc.xpath("//xmlns:SpectrumIdentificationProtocol").each do |sip|
    return sips #Array de objetos SIP     
  end
end


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
    parent_node.xpath(".//xmlns:cvParam").each do |cvP|
      cv_hash = {:name => cvP.attr("name"), :accession => cvP.attr("accession"), :value => cvP.attr("value"), :cvRef => cvP.attr("cvRef")} 
      cvParams << cv_hash
    end
    return cvParams
  end
  

  def getuserParams(parent_node)
    userParams = []
    parent_node.xpath(".//xmlns:userParam").each do |userP|
      user_hash = {:name => userP.attr("name"), :value => userP.attr("value")} 
      userParams << user_hash
    end
    return userParams
  end



##CLASE Sip SpectrumIdentificationProtocol 
SearchedModification = Struct.new(:mass_delta, :fixedMod, :residue, :unimod_accession)
SearchDB = Struct.new(:name, :location, :version, :releaseDate, :num_seq)
#A Struct is a convinient way tu bundle a number of attributes together, using accessor methods, without having to write an explicit class

class Sip
  attr_reader :sip_id, :search_type, :threshold, :analysis_software, :input_spectra, :search_db_arr, 
               :searched_modification_arr, :psi_ms_terms, :user_params
  def initialize(sip_id, search_type, threshold, analysis_software, input_spectra, search_db_arr, searched_modification_arr, psi_ms_terms, user_params)  
     @sip_id = sip_id 
     @search_type = search_type
     @threshold = threshold
     @analysis_software = analysis_software
     @input_spectra = input_spectra
     @search_db_arr = search_db_arr
     @searched_modification_arr = searched_modification_arr
     @psi_ms_terms = psi_ms_terms
     @user_params = user_params
  end
end
