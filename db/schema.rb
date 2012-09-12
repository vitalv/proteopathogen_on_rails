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

ActiveRecord::Schema.define(:version => 20120912095428) do

  create_table "fragments", :force => true do |t|
    t.integer  "spectrum_identification_item_id"
    t.integer  "charge"
    t.integer  "index"
    t.float    "m_mz"
    t.integer  "m_intensity"
    t.float    "m_error"
    t.string   "fragment_type"
    t.string   "psi_ms_cv_fragment_type_accession"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "peptide_evidences", :force => true do |t|
    t.string   "peptide_evidence_id",             :null => false
    t.string   "db_sequence_ref",                 :null => false
    t.integer  "spectrum_identification_item_id"
    t.integer  "peptide_id",                      :null => false
    t.integer  "start"
    t.integer  "end"
    t.string   "pre"
    t.string   "post"
    t.boolean  "is_decoy"
    t.string   "missed_cleavages"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "peptides", :force => true do |t|
    t.string   "mzid_scope_peptide_id"
    t.string   "sequence"
    t.string   "molecular_weight"
    t.string   "isoelectric_point"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "searched_modifications", :force => true do |t|
    t.integer  "spectrum_identification_protocol_id", :null => false
    t.float    "mass_delta"
    t.boolean  "is_fixed"
    t.string   "residue"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "sii_psi_ms_cv_terms", :force => true do |t|
    t.integer  "spectrum_identification_item_id"
    t.string   "psi_ms_cv_term_accession"
    t.string   "value"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "sip_psi_ms_cv_terms", :force => true do |t|
    t.integer  "spectrum_identification_protocol_id"
    t.string   "psi_ms_cv_term_accession"
    t.string   "value"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "sip_user_params", :force => true do |t|
    t.integer  "spectrum_identification_protocol_id_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "spectrum_identification_items", :force => true do |t|
    t.string   "sii_id",                            :null => false
    t.integer  "spectrum_identification_result_id"
    t.string   "calc_m2z"
    t.string   "exp_m2z",                           :null => false
    t.integer  "rank",                              :null => false
    t.integer  "charge_state",                      :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "pass_threshold",                    :null => false
    t.integer  "peptide_id",                        :null => false
  end

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
    t.string   "threshold",         :null => false
  end

  create_table "spectrum_identification_results", :force => true do |t|
    t.string   "sir_id",                          :null => false
    t.integer  "spectrum_identification_list_id"
    t.string   "spectrum_id"
    t.string   "spectrum_name"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

end
