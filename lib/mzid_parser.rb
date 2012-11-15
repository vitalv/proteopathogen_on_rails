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
      input_spectra_ref_arr, search_db_ref_arr = [] , []
      si.xpath(".//xmlns:InputSpectra").each do |i_s|
        input_spectra_ref_arr << i_s.attr("spectraData_ref")
      end
      si.xpath(".//xmlns:SearchDatabaseRef").each do |sdb|
        search_db_ref_arr << sdb.attr("searchDatabase_ref")
      end    
      si_arr << Si.new(si_id, sip_ref, sil_ref, input_spectra_ref_arr, search_db_ref_arr)    
    end
    return si_arr
    #por cada s_i tendre un sip. Eso es así
    #por cada s_i tendre un sil. Eso también es así
    #Por tanto, en mzid_2_db,  por cada s_i puedo llamar al método Sip(sip_id) -> que devuelve un obj Sip; y al método Sil(sil_id)   
  end
  
  def sip(sip_ref)
    sip = @doc.xpath("//xmlns:SpectrumIdentificationProtocol[@id='#{sip_ref}']")
    
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
          input_spectra = spectra_data.attr("location").split("/")[-1]
        end
      end
      
      #---- search_db_things ----
      #<SearchDatabase minOccurs: 0, maxOccurs: unbounded>
      search_db_arr = []
      unless @doc.xpath("//xmlns:SearchDatabase").empty?
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
      unless sip.xpath(".//xmlns:ModificationParams").empty?
        searched_modification_arr = []
        sip.xpath(".//xmlns:SearchModification").each do |search_mod|
          mass_d, fixed = search_mod.attr("massDelta"), search_mod.attr("fixedMod")
          residue = search_mod.attr("residues")
          unimod_ac = getcvParams(search_mod)[0][:accession] #<cvParam minOccurs:1>
          searched_modification_arr << SearchedMod.new(mass_d, fixed, residue, unimod_ac)        
        end
      end
            
      #---- parent_tol_cv_terms & fragment_tol_cv_terms ----
      parent_tolerance_node = sip.xpath(".//xmlns:ParentTolerance")[0] #<ParentTolerance maxOccurs: 1>
      parent_tolerance = getcvParams(parent_tolerance_node) unless parent_tolerance_node.nil?
      fragment_tolerance_node = sip.xpath(".//xmlns:FragmentTolerance")[0]
      fragment_tolerance = getcvParams(fragment_tolerance_node) unless fragment_tolerance_node.nil?
      
      #---- psi_ms_terms ----
      all_cvParams_per_sip = getcvParams(sip)
      psi_ms_terms = all_cvParams_per_sip.delete_if { |h| h[:cvRef] != "PSI-MS"}
      psi_ms_terms = all_cvParams_per_sip.delete_if { |h| h[:accession] =~ /MS:100141(2|3)/ }
      
      #---- user_params ----
      user_params = getuserParams(sip)
     
      sip_args_arr = [sip_id, search_type, threshold, analysis_software, input_spectra, search_db_arr, searched_modification_arr, parent_tolerance, fragment_tolerance, psi_ms_terms, user_params]
      sips << Sip.new(sip_args_arr)

    end #@doc.xpath("//xmlns:SpectrumIdentificationProtocol").each do |sip|
    return sips #Array de objetos SIP     
  end
  
  
  
  def sils
  
    sils = []
    #---- spectrum_identification_lists ---- Each SIP has one SIL
    @doc.xpath("//xmlns:SpectrumIdentificationList").each do |sil|
      sil_id = sil.attr("id")
      #sip_id = @doc.xpath("//xmlns:SpectrumIdentification").collect { |si| si.attr("spectrumIdentificationProtocol_ref") if si.attr("spectrumIdentificationList_ref") == sil_id }
      sis = @doc.xpath("//xmlns:SpectrumIdentification")
      si = sis.select { |si| si.attr("spectrumIdentificationList_ref") == sil_id }
      sip_id = si[0].attr("spectrumIdentifcationProtocol_ref") #I need sip_id here so I can insert it in the sil table
      num_seq_searched ||= sil.attr("numSequencesSearched")
    end
    sil = Sil.new(:sil_id, :sip_id, :num_seq_searched)
    sils << sil
    return sils 
    #array de objetos SIL. el metodo results de la clase sil crea un arr de objs sir, y a su vez,  el método sir.items devuelve un array de objetos sii
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
    parent_node.xpath(".//xmlns:cvParam").each do |cvP|
      cv_hash = {:name => cvP.attr("name"), :accession => cvP.attr("accession"), :value => cvP.attr("value"), :cvRef => cvP.attr("cvRef"),
      :unitAccession => cvP.attr("unitAccession"), :unitCvRef => cvP.attr("unitCvRef"), :unitName => cvP.attr("unitName")} 
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





#SpectrumIdentification.new(si_id, sip_id, sil_id, input_spectra_arr, search_db_arr)
class Si

  attr_reader :si_id, :sip_ref, :sil_ref, :input_spectra_ref_arr, :search_db_ref_arr
  
  def initialize(si_id, sip_ref, sil_ref, input_spectra_ref_arr, search_db_ref_arr)
    @si_id = si_id
    @sip_ref = sip_ref
    @sil_ref = sil_ref
    @input_spectra_ref_arr = input_spectra_ref_arr
    @search_db_ref_arr = search_db_ref_arr  
  end


end



##CLASE Sip SpectrumIdentificationProtocol 
SearchedMod = Struct.new(:mass_delta, :fixedMod, :residue, :unimod_accession)
SearchDB = Struct.new(:name, :location, :version, :releaseDate, :num_seq)
#A Struct is a convinient way tu bundle a number of attributes together, using accessor methods, without having to write an explicit class

class Sip #< SpectrumIdentification

  #super

  attr_reader :sip_id, :search_type, :threshold, :analysis_software, :input_spectra, :search_db_arr, 
               :searched_modification_arr, :parent_tolerance, :fragment_tolerance, :psi_ms_terms, :user_params
  def initialize(args_arr)  
     @sip_id = args_arr[0] 
     @search_type = args_arr[1]
     @threshold = args_arr[2]
     @analysis_software = args_arr[3]
     @input_spectra = args_arr[4]
     @search_db_arr = args_arr[5]
     @searched_modification_arr = args_arr[6]
     @parent_tolerance = args_arr[7]
     @fragment_tolerance = args_arr[8]
     @psi_ms_terms = args_arr[9]
     @user_params = args_arr[10]
  end
end




class Sil

  attr_reader :sil_id, :sip_id, :num_seq_searched

  def initialize(sil_id, sip_id, num_seq_searched)
    @sil_id = sil_id
    @sip_id = sip_id
  end


  def results

  end


end
