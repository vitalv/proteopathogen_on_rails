class Mzid2db

  def initialize(mzid_object)
    @mzid_obj = mzid_object
  end

  def save2tables
    
    puts @mzid_obj.sips[0].search_type
    puts @mzid_obj.sips[0].analysis_software
    puts @mzid_obj.sips[0].input_spectra
    puts @mzid_obj.sips[0].sip_id
    #@mzid_obj.xpath("//xmlns:SpectrumIdentificationProtocol").each { |sip| puts sip.xpath("./@id").to_s }

  end


end
