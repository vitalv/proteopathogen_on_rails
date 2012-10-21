#!/usr/bin/ruby

#rvm use 1.9.3@rails3gemset
#ruby loader.rb /home/vital/pepXML_protXML_2_mzid_V/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid

require File.expand_path(File.dirname(__FILE__)) + "/../config/environment.rb"
#require '../config/environment.rb'

#require 'bundler/setup'
require 'mzid_parser'
require 'mzid_2_db'

CURRENT_MZID_FILE = ARGV[0]
CURRENT_MZID_FILE_SHA1 = Digest::SHA1.hexdigest('/home/vital/pepXML_protXML_2_mzid_V/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid')

begin 

  #check CURRENT_MZID_FILE is not already stored

  mzid_object = Mzid.new(CURRENT_MZID_FILE)
  #mzid_object = Mzid.new("/home/vital/pepXML_protXML_2_mzid_V/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid")
  
  Mzid2db.new(mzid_object).save2tables
  
    
  rescue Exception => msg
    puts "\n#{msg}"
    rollback(saved_sip_ids)
  
  #~ rescue Exception => msg
  #~ puts msg
  #~ puts msg.backtrace
  #~ puts msg.inspect
  

end


