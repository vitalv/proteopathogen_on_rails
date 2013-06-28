CREATE TABLE `db_sequences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sequence` text COLLATE utf8_unicode_ci,
  `search_database_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=762 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `experiments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organism` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `protocol` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `researcher` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `fragments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_item_id` int(11) DEFAULT NULL,
  `charge` int(11) DEFAULT NULL,
  `index` int(11) DEFAULT NULL,
  `m_mz` float DEFAULT NULL,
  `m_intensity` int(11) DEFAULT NULL,
  `m_error` float DEFAULT NULL,
  `fragment_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `psi_ms_cv_fragment_type_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `modifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `residue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avg_mass_delta` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `peptide_id` int(11) DEFAULT NULL,
  `unimod_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1763 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `mzid_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sha1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `creator` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `submission_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `experiment_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `peptide_evidences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `peptide_id` int(11) DEFAULT NULL,
  `start` int(11) DEFAULT NULL,
  `end` int(11) DEFAULT NULL,
  `pre` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `post` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_decoy` tinyint(1) DEFAULT NULL,
  `db_sequence_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2618 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `peptide_hypotheses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `peptide_evidence_id` int(11) NOT NULL,
  `spectrum_identification_item_id` int(11) NOT NULL,
  `protein_detection_hypothesis_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `peptides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sequence` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `molecular_weight` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `isoelectric_point` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `peptide_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2585 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `protein_ambiguity_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_ambiguity_group_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `protein_detection_hypotheses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_ambiguity_group_id` int(11) DEFAULT NULL,
  `protein_detection_hypothesis_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pass_threshold` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `protein_detection_hypothesis_psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_hypothesis_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `protein_detection_hypothesis_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_hypothesis_id` int(11) DEFAULT NULL,
  `psi_ms_cv_term_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sar_si_join_table` (
  `spectra_acquisition_run_id` int(11) DEFAULT NULL,
  `spectrum_identification_id` int(11) DEFAULT NULL,
  UNIQUE KEY `index_sar_si` (`spectra_acquisition_run_id`,`spectrum_identification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sdb_si_join_table` (
  `search_database_id` int(11) DEFAULT NULL,
  `spectrum_identification_id` int(11) DEFAULT NULL,
  KEY `index_sdb_si` (`search_database_id`,`spectrum_identification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `search_databases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `release_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `number_of_sequences` int(11) DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sdb_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `searched_modifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mass_delta` decimal(4,0) DEFAULT NULL,
  `is_fixed` tinyint(1) DEFAULT NULL,
  `residue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unimod_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sii_pepevidence_join_table` (
  `spectrum_identification_item_id` int(11) DEFAULT NULL,
  `peptide_evidence_id` int(11) DEFAULT NULL,
  KEY `index_sii_pepevidence` (`spectrum_identification_item_id`,`peptide_evidence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sii_psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_item_id` int(11) DEFAULT NULL,
  `psi_ms_cv_term_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5683 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sii_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_item_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sip_psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_protocol_id` int(11) DEFAULT NULL,
  `psi_ms_cv_term_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sip_searched_mod_join_table` (
  `searched_modification_id` int(11) DEFAULT NULL,
  `spectrum_identification_protocol_id` int(11) DEFAULT NULL,
  KEY `index_sip_searched_mod` (`searched_modification_id`,`spectrum_identification_protocol_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sip_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_protocol_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=856 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sir_psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_result_id` int(11) NOT NULL,
  `psi_ms_cv_term` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sir_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_result_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `spectra_acquisition_runs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fraction` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `instrument` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ionization` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `analyzer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `spectra_file` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mzid_file_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `spectrum_identification_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sii_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `spectrum_identification_result_id` int(11) DEFAULT NULL,
  `calc_m2z` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `exp_m2z` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `rank` int(11) NOT NULL,
  `charge_state` int(11) NOT NULL,
  `pass_threshold` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2844 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `spectrum_identification_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sil_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `num_seq_searched` int(11) DEFAULT NULL,
  `spectrum_identification_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `spectrum_identification_protocols` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sip_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `analysis_software` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `search_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `threshold` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `parent_tol_plus_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_tol_minus_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_tol_plus_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_tol_minus_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `spectrum_identification_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `spectrum_identification_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sir_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `spectrum_identification_list_id` int(11) DEFAULT NULL,
  `spectrum_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `spectrum_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2844 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `spectrum_identifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `si_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activity_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20120907133329');

INSERT INTO schema_migrations (version) VALUES ('20120907141137');

INSERT INTO schema_migrations (version) VALUES ('20120909103200');

INSERT INTO schema_migrations (version) VALUES ('20120909154217');

INSERT INTO schema_migrations (version) VALUES ('20120910090202');

INSERT INTO schema_migrations (version) VALUES ('20120910101515');

INSERT INTO schema_migrations (version) VALUES ('20120910134651');

INSERT INTO schema_migrations (version) VALUES ('20120911093752');

INSERT INTO schema_migrations (version) VALUES ('20120911102810');

INSERT INTO schema_migrations (version) VALUES ('20120911160330');

INSERT INTO schema_migrations (version) VALUES ('20120911160347');

INSERT INTO schema_migrations (version) VALUES ('20120912091838');

INSERT INTO schema_migrations (version) VALUES ('20120912092037');

INSERT INTO schema_migrations (version) VALUES ('20120912095328');

INSERT INTO schema_migrations (version) VALUES ('20120912095428');

INSERT INTO schema_migrations (version) VALUES ('20120912104036');

INSERT INTO schema_migrations (version) VALUES ('20120912134303');

INSERT INTO schema_migrations (version) VALUES ('20120912144244');

INSERT INTO schema_migrations (version) VALUES ('20120913150822');

INSERT INTO schema_migrations (version) VALUES ('20120914084711');

INSERT INTO schema_migrations (version) VALUES ('20120914085010');

INSERT INTO schema_migrations (version) VALUES ('20120914085839');

INSERT INTO schema_migrations (version) VALUES ('20120914101407');

INSERT INTO schema_migrations (version) VALUES ('20120917083734');

INSERT INTO schema_migrations (version) VALUES ('20120917105056');

INSERT INTO schema_migrations (version) VALUES ('20120917125619');

INSERT INTO schema_migrations (version) VALUES ('20120917125645');

INSERT INTO schema_migrations (version) VALUES ('20120917145357');

INSERT INTO schema_migrations (version) VALUES ('20120917151851');

INSERT INTO schema_migrations (version) VALUES ('20120918083924');

INSERT INTO schema_migrations (version) VALUES ('20120918090905');

INSERT INTO schema_migrations (version) VALUES ('20120918092740');

INSERT INTO schema_migrations (version) VALUES ('20120918094503');

INSERT INTO schema_migrations (version) VALUES ('20121015135236');

INSERT INTO schema_migrations (version) VALUES ('20121015135929');

INSERT INTO schema_migrations (version) VALUES ('20121015140047');

INSERT INTO schema_migrations (version) VALUES ('20121015150257');

INSERT INTO schema_migrations (version) VALUES ('20121015150554');

INSERT INTO schema_migrations (version) VALUES ('20121015150603');

INSERT INTO schema_migrations (version) VALUES ('20121015150756');

INSERT INTO schema_migrations (version) VALUES ('20121015150818');

INSERT INTO schema_migrations (version) VALUES ('20121016104529');

INSERT INTO schema_migrations (version) VALUES ('20121017133358');

INSERT INTO schema_migrations (version) VALUES ('20121017150138');

INSERT INTO schema_migrations (version) VALUES ('20121018104719');

INSERT INTO schema_migrations (version) VALUES ('20121018105705');

INSERT INTO schema_migrations (version) VALUES ('20121018111031');

INSERT INTO schema_migrations (version) VALUES ('20121018111321');

INSERT INTO schema_migrations (version) VALUES ('20121018151506');

INSERT INTO schema_migrations (version) VALUES ('20121019084932');

INSERT INTO schema_migrations (version) VALUES ('20121021165459');

INSERT INTO schema_migrations (version) VALUES ('20121021165515');

INSERT INTO schema_migrations (version) VALUES ('20121022162202');

INSERT INTO schema_migrations (version) VALUES ('20121023103923');

INSERT INTO schema_migrations (version) VALUES ('20121023123150');

INSERT INTO schema_migrations (version) VALUES ('20121024131937');

INSERT INTO schema_migrations (version) VALUES ('20121024132312');

INSERT INTO schema_migrations (version) VALUES ('20121024143533');

INSERT INTO schema_migrations (version) VALUES ('20121102095655');

INSERT INTO schema_migrations (version) VALUES ('20121102100850');

INSERT INTO schema_migrations (version) VALUES ('20121106091351');

INSERT INTO schema_migrations (version) VALUES ('20121106091642');

INSERT INTO schema_migrations (version) VALUES ('20121106091832');

INSERT INTO schema_migrations (version) VALUES ('20121106121405');

INSERT INTO schema_migrations (version) VALUES ('20121115091323');

INSERT INTO schema_migrations (version) VALUES ('20121115093416');

INSERT INTO schema_migrations (version) VALUES ('20121115093432');

INSERT INTO schema_migrations (version) VALUES ('20121115095547');

INSERT INTO schema_migrations (version) VALUES ('20121115095847');

INSERT INTO schema_migrations (version) VALUES ('20121115100624');

INSERT INTO schema_migrations (version) VALUES ('20121115101415');

INSERT INTO schema_migrations (version) VALUES ('20121115101437');

INSERT INTO schema_migrations (version) VALUES ('20121120115755');

INSERT INTO schema_migrations (version) VALUES ('20121120163314');

INSERT INTO schema_migrations (version) VALUES ('20121120163327');

INSERT INTO schema_migrations (version) VALUES ('20121120163359');

INSERT INTO schema_migrations (version) VALUES ('20121120163418');

INSERT INTO schema_migrations (version) VALUES ('20121120164115');

INSERT INTO schema_migrations (version) VALUES ('20130116152856');

INSERT INTO schema_migrations (version) VALUES ('20130117094425');

INSERT INTO schema_migrations (version) VALUES ('20130118151332');

INSERT INTO schema_migrations (version) VALUES ('20130121135619');

INSERT INTO schema_migrations (version) VALUES ('20130130140829');

INSERT INTO schema_migrations (version) VALUES ('20130130145123');

INSERT INTO schema_migrations (version) VALUES ('20130130170612');

INSERT INTO schema_migrations (version) VALUES ('20130625134859');

INSERT INTO schema_migrations (version) VALUES ('20130626114435');

INSERT INTO schema_migrations (version) VALUES ('20130627102435');

INSERT INTO schema_migrations (version) VALUES ('20130627102518');

INSERT INTO schema_migrations (version) VALUES ('20130627102920');