class HomeController < ApplicationController
  
  def index
    
    @experiment_count = Experiment.count
    @mzid_file_count = MzidFile.count
    @msruns_count = SpectrumIdentification.count
    
    
    @peptide_evidence_count = PeptideEvidence.count
    #this is scoped to mzid, pepev_id attr contains Mzid_ :
    ##<PeptideEvidence id: 1, start: 633, end: 643, pre: "R", post: "D", is_decoy: nil, db_sequence_id: 1, peptide_sequence_id: 1, pepev_id: "peptide_1_1_SDB_1_orf19.6092_633_643_Mzid_1">
    #so it is a inter-experiment cumulative total
    
    @peptide_sequence_count = PeptideSequence.count
    @psm_count = PeptideSpectrumAssignment.count
    @pdh_count = ProteinDetectionHypothesis.count
    #To get a number of proteins I can get:
    #Accessions from DbSequence
    #@dbseq_accession_count = DbSequence.all.map { |d| d.accession}
    #@distinct_dbseq_accession_count = DbSequence.all.map { |d| d.accession}.uniq.count #remember DbSeq accession is scoped to sdb_id in DbSeq model so I need the ".uniq" to get proteins are considered different 
    
    @candida_decoy_filtered_dbseq_accs = DbSequence.all.map{|d| d.accession}.delete_if{|d| d !~ /^orf|Ca/i}.count
    #@candida_decoy_filtered_dbseq_accs = decoy_filtered_dbseq_accs.delete_if{|a| a =~ /Human|Yeast|Bovin|Pig|Chick/i}.count
    
    #Actual DbSequence (protein) sequences
    @dbseq_sequence_count = DbSequence.all.map { |d| d.sequence}.count
    
  end
  
  def download_mayu_fdr
    send_file("#{Rails.root}/public/mayu_FDR_analysis.csv", filename: "mayu_FDR_analysis.csv")
  end  
  

end
