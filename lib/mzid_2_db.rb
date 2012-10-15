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
      input_spectra = sip.input_spectra
      analysis_software = sip.analysis_software
      search_type = sip.search_type
      threshold = sip.threshold
      
      search_db_arr = sip.search_db_arr #first_or_create
      searched_mod_arr = sip.searched_modification_arr
      psi_ms_terms = sip.psi_ms_terms
      user_params = sip.user_params
      
      search_db_arr.each do |sdb|
        SearchDatabase.new(sdb.name
        sdb.first_or_create
      end
      
      sip = SpectrumIdentificationProtocol.new(:sip_id, :input_spectra, :analysis_software, :search_type, :threshold)
      
    #  puts "\n\tSearched Modifications:"
    #  sip.searched_modification_arr.each do |struct|
    #    puts "\tMassD: #{struct.mass_delta} - Fixed: #{struct.fixedMod} - Residue: #{struct.residue} - UnimodAc: #{struct.unimod_accession}"
    #  end
      
    #  puts "\n\tSearch DB:"
    #  sip.search_db_arr.each do |sdb_struct| #(:name, :location, :version, :releaseDate, :num_seq)
    #    puts "\tName: #{sdb_struct.name} - Location: #{sdb_struct.location} - Version : #{sdb_struct.version}"
    #  end     
      
    #  puts "\n\tPSI-MS terms:"
    #  sip.psi_ms_terms.each do |h|
    #    puts "\tAccession: #{h[:accession]} - Name: #{h[:name]} - Value: #{h[:value]}"
    #  end      
      
    #  puts "\n\tUser Params:"
    #  sip.user_params.each do |h|
    #    puts "\tName: #{h[:name]} - Value: #{h[:value]}"
    #  end        
      
    end
  end


end
