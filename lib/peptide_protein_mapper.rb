module  PeptideProteinMapper

  #attr_reader :db_sequence, :peptide_sequences

  def map_peptides_2_protein(db_sequence, peptide_sequences)
    protein_sequence = db_sequence.sequence
    if (protein_sequence and !protein_sequence.blank?) and (peptide_sequences and !peptide_sequences.blank?)
      offsets = []
      peptide_sequences.each {|pepseq| protein_sequence.scan(pepseq){offsets << $~.offset(0)} }
      unless offsets.blank? #pepseq not found in protseq, should not happen, just catch this possibility
        ranges = offsets.map { |o| o[0]..o[1] }
        #Convert offsets from arrays to ranges to use def merge_ranges
        coverage_ranges = merge_ranges(ranges) #[5..17, 34..63]
        coverage_offsets = coverage_ranges.map {|r| [r.first, r.last] } #[[5, 17], [34, 63]]
        #then convert back to arrays
        prot_seq_w_cov_tags = db_sequence.prot_seq_highlighted_coverage(coverage_offsets)      
        covered_length = 0
        coverage_offsets.each { |c| covered_length += c[1]-c[0] }      
        sequence_coverage = ((covered_length * 100).to_f / protein_sequence.length.to_f).round 2
      end
      return [sequence_coverage, prot_seq_w_cov_tags]
    else
    
    end
  
  end
  
  
  
  private
  
  def merge_ranges(ranges) #main:Object
    ranges = ranges.sort_by {|r| r.first }
    *outages = ranges.shift
    ranges.each do |r|
      lastr = outages[-1]
      if lastr.last >= r.first - 1
        outages[-1] = lastr.first..[r.last, lastr.last].max
      else
        outages.push(r)
      end
    end
    outages
  end  
  
end
