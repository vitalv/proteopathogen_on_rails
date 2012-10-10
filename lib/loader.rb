#!/usr/bin/ruby

require 'rubygems'
require 'mzid_parser'
require 'mzid_2_db'

begin 

  mzid_object = Mzid.new(ARGV[0])
  
  Mzid2db.new(mzid_object).save2tables
  
  rescue Exception => msg
  puts msg
  puts msg.backtrace
  puts msg.inspect
  

end


