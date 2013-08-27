-- MySQL dump 10.13  Distrib 5.5.32, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: proteopathogen3_devel
-- ------------------------------------------------------
-- Server version	5.5.32-0ubuntu0.13.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `db_sequences`
--

DROP TABLE IF EXISTS `db_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_sequences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `sequence` text COLLATE utf8_unicode_ci,
  `search_database_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2369 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `experiments`
--

DROP TABLE IF EXISTS `experiments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `experiments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organism` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `protocol` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `researcher` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fragments`
--

DROP TABLE IF EXISTS `fragments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modifications`
--

DROP TABLE IF EXISTS `modifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `residue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avg_mass_delta` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unimod_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `peptide_evidence_id` int(11) DEFAULT NULL,
  `peptide_sequence_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4271 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mzid_files`
--

DROP TABLE IF EXISTS `mzid_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mzid_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sha1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `creator` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `submission_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `experiment_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdh_psi_ms_cv_terms`
--

DROP TABLE IF EXISTS `pdh_psi_ms_cv_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pdh_psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_hypothesis_id` int(11) DEFAULT NULL,
  `psi_ms_cv_term_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1881 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdh_user_params`
--

DROP TABLE IF EXISTS `pdh_user_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pdh_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_hypothesis_id` int(11) DEFAULT NULL,
  `name` text COLLATE utf8_unicode_ci,
  `value` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14915 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdp_psi_ms_cv_terms`
--

DROP TABLE IF EXISTS `pdp_psi_ms_cv_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pdp_psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_protocol_id` int(11) DEFAULT NULL,
  `psi_ms_cv_term_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pdp_psi_ms_cv_terms_on_protein_detection_protocol_id` (`protein_detection_protocol_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pdp_user_params`
--

DROP TABLE IF EXISTS `pdp_user_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pdp_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_protocol_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pdp_user_params_on_protein_detection_protocol_id` (`protein_detection_protocol_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `peptide_evidences`
--

DROP TABLE IF EXISTS `peptide_evidences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peptide_evidences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start` int(11) DEFAULT NULL,
  `end` int(11) DEFAULT NULL,
  `pre` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `post` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_decoy` tinyint(1) DEFAULT NULL,
  `db_sequence_id` int(11) DEFAULT NULL,
  `peptide_sequence_id` int(11) DEFAULT NULL,
  `pepev_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6817 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `peptide_hypotheses`
--

DROP TABLE IF EXISTS `peptide_hypotheses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peptide_hypotheses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_hypothesis_id` int(11) NOT NULL,
  `peptide_spectrum_assignment_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10963 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `peptide_sequences`
--

DROP TABLE IF EXISTS `peptide_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peptide_sequences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sequence` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `molecular_weight` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `isoelectric_point` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6604 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `peptide_spectrum_assignments`
--

DROP TABLE IF EXISTS `peptide_spectrum_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peptide_spectrum_assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_item_id` int(11) DEFAULT NULL,
  `peptide_evidence_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13728 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protein_ambiguity_groups`
--

DROP TABLE IF EXISTS `protein_ambiguity_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protein_ambiguity_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_ambiguity_group_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `protein_detection_list_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1807 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protein_detection_hypotheses`
--

DROP TABLE IF EXISTS `protein_detection_hypotheses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protein_detection_hypotheses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_ambiguity_group_id` int(11) DEFAULT NULL,
  `protein_detection_hypothesis_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pass_threshold` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1873 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protein_detection_lists`
--

DROP TABLE IF EXISTS `protein_detection_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protein_detection_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_id` int(11) DEFAULT NULL,
  `pdl_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_protein_detection_lists_on_protein_detection_id` (`protein_detection_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protein_detection_protocols`
--

DROP TABLE IF EXISTS `protein_detection_protocols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protein_detection_protocols` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_id` int(11) DEFAULT NULL,
  `pdp_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `analysis_software` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_protein_detection_protocols_on_protein_detection_id` (`protein_detection_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protein_detections`
--

DROP TABLE IF EXISTS `protein_detections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protein_detections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `protein_detection_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `psi_ms_cv_terms`
--

DROP TABLE IF EXISTS `psi_ms_cv_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sdb_si_join_table`
--

DROP TABLE IF EXISTS `sdb_si_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sdb_si_join_table` (
  `search_database_id` int(11) DEFAULT NULL,
  `spectrum_identification_id` int(11) DEFAULT NULL,
  KEY `index_sdb_si` (`search_database_id`,`spectrum_identification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `search_databases`
--

DROP TABLE IF EXISTS `search_databases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_databases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `release_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `number_of_sequences` int(11) DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sdb_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `searched_modifications`
--

DROP TABLE IF EXISTS `searched_modifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `searched_modifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mass_delta` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_fixed` tinyint(1) DEFAULT NULL,
  `residue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unimod_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sii_psi_ms_cv_terms`
--

DROP TABLE IF EXISTS `sii_psi_ms_cv_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sii_psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_item_id` int(11) DEFAULT NULL,
  `psi_ms_cv_term_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61603 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sii_user_params`
--

DROP TABLE IF EXISTS `sii_user_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sii_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_item_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=192928 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sip_psi_ms_cv_terms`
--

DROP TABLE IF EXISTS `sip_psi_ms_cv_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sip_psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_protocol_id` int(11) DEFAULT NULL,
  `psi_ms_cv_term_accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sip_searched_mod_join_table`
--

DROP TABLE IF EXISTS `sip_searched_mod_join_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sip_searched_mod_join_table` (
  `searched_modification_id` int(11) DEFAULT NULL,
  `spectrum_identification_protocol_id` int(11) DEFAULT NULL,
  KEY `index_sip_searched_mod` (`searched_modification_id`,`spectrum_identification_protocol_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sip_user_params`
--

DROP TABLE IF EXISTS `sip_user_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sip_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_protocol_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1525 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sir_psi_ms_cv_terms`
--

DROP TABLE IF EXISTS `sir_psi_ms_cv_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sir_psi_ms_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_result_id` int(11) NOT NULL,
  `psi_ms_cv_term` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2187 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sir_user_params`
--

DROP TABLE IF EXISTS `sir_user_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sir_user_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `spectrum_identification_result_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spectra_acquisition_runs`
--

DROP TABLE IF EXISTS `spectra_acquisition_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spectra_acquisition_runs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fraction` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `instrument` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ionization` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `analyzer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `spectra_file` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `spectrum_identification_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spectrum_identification_items`
--

DROP TABLE IF EXISTS `spectrum_identification_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=27572 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spectrum_identification_lists`
--

DROP TABLE IF EXISTS `spectrum_identification_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spectrum_identification_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sil_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `num_seq_searched` int(11) DEFAULT NULL,
  `spectrum_identification_id` int(11) DEFAULT NULL,
  `protein_detection_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spectrum_identification_protocols`
--

DROP TABLE IF EXISTS `spectrum_identification_protocols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spectrum_identification_results`
--

DROP TABLE IF EXISTS `spectrum_identification_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spectrum_identification_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sir_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `spectrum_identification_list_id` int(11) DEFAULT NULL,
  `spectrum_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `spectrum_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26513 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spectrum_identifications`
--

DROP TABLE IF EXISTS `spectrum_identifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spectrum_identifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `si_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activity_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mzid_file_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unimod_cv_terms`
--

DROP TABLE IF EXISTS `unimod_cv_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unimod_cv_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accession` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-08-26 13:19:13
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

INSERT INTO schema_migrations (version) VALUES ('20130701132830');

INSERT INTO schema_migrations (version) VALUES ('20130701143558');

INSERT INTO schema_migrations (version) VALUES ('20130701143800');

INSERT INTO schema_migrations (version) VALUES ('20130701145451');

INSERT INTO schema_migrations (version) VALUES ('20130701152148');

INSERT INTO schema_migrations (version) VALUES ('20130701153414');

INSERT INTO schema_migrations (version) VALUES ('20130703135117');

INSERT INTO schema_migrations (version) VALUES ('20130703140136');

INSERT INTO schema_migrations (version) VALUES ('20130703141014');

INSERT INTO schema_migrations (version) VALUES ('20130704132017');

INSERT INTO schema_migrations (version) VALUES ('20130704132107');

INSERT INTO schema_migrations (version) VALUES ('20130704132212');

INSERT INTO schema_migrations (version) VALUES ('20130704132318');

INSERT INTO schema_migrations (version) VALUES ('20130704132349');

INSERT INTO schema_migrations (version) VALUES ('20130705102629');

INSERT INTO schema_migrations (version) VALUES ('20130705113626');

INSERT INTO schema_migrations (version) VALUES ('20130708083701');

INSERT INTO schema_migrations (version) VALUES ('20130708095205');

INSERT INTO schema_migrations (version) VALUES ('20130709160254');

INSERT INTO schema_migrations (version) VALUES ('20130718150512');

INSERT INTO schema_migrations (version) VALUES ('20130718151044');

INSERT INTO schema_migrations (version) VALUES ('20130725130205');

INSERT INTO schema_migrations (version) VALUES ('20130726084545');

INSERT INTO schema_migrations (version) VALUES ('20130731083017');

INSERT INTO schema_migrations (version) VALUES ('20130731083715');
