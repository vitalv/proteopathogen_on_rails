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
    
      puts "\nSIP: #{sip.sip_id} - Software: #{sip.analysis_software} - Search type: #{sip.search_type}"
      sip_id = sip.sip_id
      activity_date = "DE:DONDE:SACO:ESTO"
      input_spectra = sip.input_spectra
      search_db = 
      this_SIP = SpectrumIdentificationProtocol.new(:sip_id, :activity_date, :input_spectra
      
      puts "\n\tSearched Modifications:"
      sip.searched_modification_arr.each do |struct|
        puts "\tMassD: #{struct.mass_delta} - Fixed: #{struct.fixedMod} - Residue: #{struct.residue} - UnimodAc: #{struct.unimod_accession}"
      end
      
      puts "\n\tSearch DB:"
      sip.search_db_arr.each do |sdb_struct| #(:name, :location, :version, :releaseDate, :num_seq)
        puts "\tName: #{sdb_struct.name} - Location: #{sdb_struct.location} - Version : #{sdb_struct.version}"
      end     
      
      puts "\n\tPSI-MS terms:"
      sip.psi_ms_terms.each do |h|
        puts "\tAccession: #{h[:accession]} - Name: #{h[:name]} - Value: #{h[:value]}"
      end      
      
      puts "\n\tUser Params:"
      sip.user_params.each do |h|
        puts "\tName: #{h[:name]} - Value: #{h[:value]}"
      end        
      
    end
  end


end
