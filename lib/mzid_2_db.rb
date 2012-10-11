class Mzid2db

  def initialize(mzid_object)
    @mzid_obj = mzid_object
  end

  def save2tables
    
    #~ puts @mzid_obj.sips[0].search_type
    #~ puts @mzid_obj.sips[0].analysis_software
    #~ puts @mzid_obj.sips[0].input_spectra
    #~ puts @mzid_obj.sips[0].sip_id
    @mzid_obj.sips.each do |sip|
      puts "SIP: #{sip.sip_id} - Software: #{sip.analysis_software} - Search type: #{sip.search_type}"
      puts "\tSearched Modifications:"
      sip.searched_modification_arr.each do |struct|
        puts "\tMassD: #{struct.mass_delta} - Fixed: #{struct.fixedMod} - Residue: #{struct.residue} - UnimodAc: #{struct.unimod_accession}"
      end
      puts "\tPSI-MS terms:"
      sip.psi_ms_terms.each do |h|
        puts "\tAccession: #{h[:accession]} - Name: #{h[:name]} - Value: #{h[:value]}"
      end      
      puts "\tUser Params:"
      sip.user_params.each do |h|
        puts "\tName: #{h[:name]} - Value: #{h[:value]}"
      end        
      
    end
  end


end
