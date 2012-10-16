#!/usr/bin/ruby

#rvm use 1.9.3@rails3gemset
#ruby loader.rb /home/vital/pepXML_protXML_2_mzid_V/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid

require "#{File.dirname(__FILE__)}/../config/environment.rb"
#require './config/environment.rb'

require 'bundler/setup'
$: << 'lib/'
require 'mzid_parser'
require 'mzid_2_db'

begin 

  mzid_object = Mzid.new(ARGV[0])
  #mzid_object = Mzid.new("/home/vital/pepXML_protXML_2_mzid_V/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid")
  
  Mzid2db.new(mzid_object).save2tables
  
  rescue Exception => msg
  puts msg
  puts msg.backtrace
  puts msg.inspect
  

end


