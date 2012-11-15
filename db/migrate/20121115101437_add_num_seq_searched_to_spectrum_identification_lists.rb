class AddNumSeqSearchedToSpectrumIdentificationLists < ActiveRecord::Migration
  def change
    add_column :spectrum_identification_lists, :num_seq_searched, :integer
  end
end
