# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120907141137) do

  create_table "spectrum_identification_lists", :force => true do |t|
    t.string   "sil_id",                              :null => false
    t.integer  "spectrum_identification_protocol_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "spectrum_identification_protocols", :force => true do |t|
    t.string   "sip_id",            :null => false
    t.string   "activity_date"
    t.string   "input_spectra"
    t.string   "search_database"
    t.string   "analysis_software"
    t.string   "search_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
