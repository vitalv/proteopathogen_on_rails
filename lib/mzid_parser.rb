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
          
      sip_id = sip.xpath("./@id").to_s
      
      #<SearchType minOccurs:1 >
      this_search_type_node = sip.xpath(".//xmlns:SearchType")
      search_type = get_cvParam_and_or_userParam(this_search_type_node)
      
      analysisSoftware_ref, analysis_software = sip.xpath("./@analysisSoftware_ref").to_s, ""
      @doc.xpath("//xmlns:AnalysisSoftware").each do |soft|
        if soft.xpath("./@id").to_s == analysisSoftware_ref
          software_name_node = soft.xpath(".//xmlns:SoftwareName")
          analysis_software = get_cvParam_and_or_userParam(software_name_node)
        end
      end      
      
      input_spectra, spectraData_ref = "" , ""
      #<AnalysisCollection minOccurs:1> | <SpectrumIdentification minOccurs:1 max:unbounded>
      #Para obtener input_spectra tengo que buscar en 2 sitios:
      #1º Con mi sip_id busco en <SpectrumIdentification> para obtener spectraData_ref
      @doc.xpath("//xmlns:SpectrumIdentification").each do |si|
        if si.xpath("./@spectrumIdentificationProtocol_ref").to_s == sip_id #spectrumIdentificationProtocol_ref : required
          spectraData_ref = si.xpath(".//xmlns:InputSpectra/@spectraData_ref").to_s
        end
      end 
      #2º Una vez obtenido el spectraData_ref puedo buscar en <SpectraData>
      @doc.xpath("//xmlns:SpectraData").each do |spectra_data| #<DataCollection> : <Inputs> : <SpectraData>
        if spectra_data.xpath("./@id").to_s == spectraData_ref
          input_spectra = spectra_data.xpath("./@location").to_s
        end
      end
      
      sips << Sip.new(sip_id, search_type, analysis_software, input_spectra)      

    end
    
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
      break
      puts "there must be at least cvParam and/or userParam under #{node.node_name}"
    end
  end
  

  def getcvParams(parent_node)
    cvParams = []
    parent_node.xpath(".//xmlns:cvParam").each do |cvP|
      cv_hash = {:name => cvP.xpath("./@name").to_s , :accession => cvP.xpath("./@accession").to_s, :value => cvP.xpath("./@value").to_s} 
      cvParams << cv_hash
    end
    return cvParams
  end
  

  def getuserParams(parent_node)
    userParams = []
    parent_node.xpath(".//xmlns:userParam").each do |userP|
      user_hash = {:name => userP.xpath("./@name").to_s , :accession => userP.xpath("./@accession").to_s, :value => userP.xpath("./@value").to_s} 
      userParams << user_hash
    end
    return userParams
  end




class Sip
  attr_reader :sip_id, :search_type, :analysis_software, :input_spectra  
  def initialize(sip_id, search_type, analysis_software, input_spectra)  
     @sip_id = sip_id 
     @search_type = search_type
     @analysis_software = analysis_software
     @input_spectra = input_spectra
  end
end
