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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140313153432) do

  create_table "db_sequences", force: true do |t|
    t.string  "accession"
    t.text    "description"
    t.text    "sequence"
    t.integer "search_database_id"
  end

  create_table "experiments", force: true do |t|
    t.string "organism"
    t.text   "protocol"
    t.string "date"
    t.string "researcher"
    t.string "pmid"
    t.string "short_label"
    t.string "slug"
  end

  add_index "experiments", ["short_label"], name: "index_experiments_on_short_label", unique: true, using: :btree
  add_index "experiments", ["slug"], name: "index_experiments_on_slug", using: :btree

  create_table "fragments", force: true do |t|
    t.integer "spectrum_identification_item_id"
    t.integer "charge"
    t.integer "index"
    t.float   "m_mz"
    t.integer "m_intensity"
    t.float   "m_error"
    t.string  "fragment_type"
    t.string  "psi_ms_cv_fragment_type_accession"
  end

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "modifications", force: true do |t|
    t.string  "residue"
    t.string  "location"
    t.string  "avg_mass_delta"
    t.string  "unimod_accession"
    t.integer "peptide_evidence_id"
    t.integer "peptide_sequence_id"
  end

  create_table "mzid_files", force: true do |t|
    t.string  "location"
    t.string  "sha1"
    t.string  "creator"
    t.string  "submission_date"
    t.string  "name"
    t.integer "experiment_id"
    t.string  "slug"
  end

  add_index "mzid_files", ["name"], name: "index_mzid_files_on_name", unique: true, using: :btree
  add_index "mzid_files", ["slug"], name: "index_mzid_files_on_slug", using: :btree

  create_table "pdh_psi_ms_cv_terms", force: true do |t|
    t.integer "protein_detection_hypothesis_id"
    t.string  "psi_ms_cv_term_accession"
    t.string  "value"
  end

  create_table "pdh_user_params", force: true do |t|
    t.integer "protein_detection_hypothesis_id"
    t.string  "name"
    t.text    "value"
  end

  create_table "pdp_psi_ms_cv_terms", force: true do |t|
    t.integer "protein_detection_protocol_id"
    t.string  "psi_ms_cv_term_accession"
    t.string  "value"
  end

  add_index "pdp_psi_ms_cv_terms", ["protein_detection_protocol_id"], name: "index_pdp_psi_ms_cv_terms_on_protein_detection_protocol_id", using: :btree

  create_table "pdp_user_params", force: true do |t|
    t.integer "protein_detection_protocol_id"
    t.string  "name"
    t.string  "value"
  end

  add_index "pdp_user_params", ["protein_detection_protocol_id"], name: "index_pdp_user_params_on_protein_detection_protocol_id", using: :btree

  create_table "peptide_evidences", force: true do |t|
    t.integer "start"
    t.integer "end"
    t.string  "pre"
    t.string  "post"
    t.boolean "is_decoy"
    t.integer "db_sequence_id"
    t.integer "peptide_sequence_id"
    t.string  "pepev_id"
  end

  create_table "peptide_hypotheses", force: true do |t|
    t.integer "protein_detection_hypothesis_id", null: false
    t.integer "peptide_spectrum_assignment_id"
  end

  create_table "peptide_sequences", force: true do |t|
    t.string "sequence"
    t.string "molecular_weight"
    t.string "isoelectric_point"
  end

  create_table "peptide_spectrum_assignments", force: true do |t|
    t.integer "spectrum_identification_item_id"
    t.integer "peptide_evidence_id"
  end

  create_table "protein_ambiguity_groups", force: true do |t|
    t.string  "protein_ambiguity_group_id"
    t.integer "protein_detection_list_id"
  end

  create_table "protein_detection_hypotheses", force: true do |t|
    t.integer "protein_ambiguity_group_id"
    t.string  "protein_detection_hypothesis_id"
    t.string  "pass_threshold"
    t.string  "name"
  end

  create_table "protein_detection_lists", force: true do |t|
    t.integer "protein_detection_id"
    t.string  "pdl_id"
  end

  add_index "protein_detection_lists", ["protein_detection_id"], name: "index_protein_detection_lists_on_protein_detection_id", using: :btree

  create_table "protein_detection_protocols", force: true do |t|
    t.integer "protein_detection_id"
    t.string  "pdp_id"
    t.string  "name"
    t.string  "analysis_software"
  end

  add_index "protein_detection_protocols", ["protein_detection_id"], name: "index_protein_detection_protocols_on_protein_detection_id", using: :btree

  create_table "protein_detections", force: true do |t|
    t.string "protein_detection_id"
    t.string "name"
  end

  create_table "psi_ms_cv_terms", force: true do |t|
    t.string "accession"
    t.string "name"
  end

  create_table "sdb_si_join_table", id: false, force: true do |t|
    t.integer "search_database_id"
    t.integer "spectrum_identification_id"
  end

  add_index "sdb_si_join_table", ["search_database_id", "spectrum_identification_id"], name: "index_sdb_si", using: :btree

  create_table "search_databases", force: true do |t|
    t.string  "name"
    t.string  "version"
    t.string  "release_date"
    t.integer "number_of_sequences"
    t.string  "location"
    t.string  "sdb_id",              null: false
  end

  create_table "searched_modifications", force: true do |t|
    t.decimal "mass_delta",       precision: 4, scale: 0
    t.boolean "is_fixed"
    t.string  "residue"
    t.string  "unimod_accession"
  end

  create_table "sii_pepevidence_join_table", id: false, force: true do |t|
    t.integer "spectrum_identification_item_id"
    t.integer "peptide_evidence_id"
  end

  add_index "sii_pepevidence_join_table", ["spectrum_identification_item_id", "peptide_evidence_id"], name: "index_sii_pepevidence", using: :btree

  create_table "sii_psi_ms_cv_terms", force: true do |t|
    t.integer "spectrum_identification_item_id"
    t.string  "psi_ms_cv_term_accession"
    t.string  "value"
  end

  create_table "sii_user_params", force: true do |t|
    t.integer "spectrum_identification_item_id"
    t.string  "name"
    t.string  "value"
  end

  create_table "sip_psi_ms_cv_terms", force: true do |t|
    t.integer "spectrum_identification_protocol_id"
    t.string  "psi_ms_cv_term_accession"
    t.string  "value"
  end

  create_table "sip_searched_mod_join_table", id: false, force: true do |t|
    t.integer "searched_modification_id"
    t.integer "spectrum_identification_protocol_id"
  end

  add_index "sip_searched_mod_join_table", ["searched_modification_id", "spectrum_identification_protocol_id"], name: "index_sip_searched_mod", using: :btree

  create_table "sip_user_params", force: true do |t|
    t.integer "spectrum_identification_protocol_id"
    t.string  "name"
    t.string  "value"
  end

  create_table "sir_psi_ms_cv_terms", force: true do |t|
    t.integer "spectrum_identification_result_id", null: false
    t.string  "psi_ms_cv_term"
    t.string  "value"
  end

  create_table "sir_user_params", force: true do |t|
    t.integer "spectrum_identification_result_id", null: false
    t.string  "name"
    t.string  "value"
  end

  create_table "spectra_acquisition_runs", force: true do |t|
    t.string  "fraction"
    t.string  "instrument"
    t.string  "ionization"
    t.string  "analyzer"
    t.string  "spectra_file"
    t.integer "spectrum_identification_id"
  end

  create_table "spectrum_identification_items", force: true do |t|
    t.string  "sii_id",                            null: false
    t.integer "spectrum_identification_result_id"
    t.string  "calc_m2z"
    t.string  "exp_m2z",                           null: false
    t.integer "rank",                              null: false
    t.integer "charge_state",                      null: false
    t.string  "pass_threshold",                    null: false
  end

  create_table "spectrum_identification_lists", force: true do |t|
    t.string  "sil_id",                     null: false
    t.integer "num_seq_searched"
    t.integer "spectrum_identification_id"
    t.integer "protein_detection_id"
  end

  create_table "spectrum_identification_protocols", force: true do |t|
    t.string  "sip_id",                     null: false
    t.string  "analysis_software"
    t.string  "search_type"
    t.string  "threshold",                  null: false
    t.string  "parent_tol_plus_value"
    t.string  "parent_tol_minus_value"
    t.string  "fragment_tol_plus_value"
    t.string  "fragment_tol_minus_value"
    t.integer "spectrum_identification_id"
  end

  create_table "spectrum_identification_results", force: true do |t|
    t.string  "sir_id",                          null: false
    t.integer "spectrum_identification_list_id"
    t.string  "spectrum_id"
    t.string  "spectrum_name"
  end

  create_table "spectrum_identifications", force: true do |t|
    t.string  "si_id",         null: false
    t.string  "name"
    t.string  "activity_date"
    t.integer "mzid_file_id"
  end

  create_table "unimod_cv_terms", force: true do |t|
    t.string "accession"
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
