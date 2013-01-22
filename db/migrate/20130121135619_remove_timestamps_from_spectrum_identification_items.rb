class RemoveTimestampsFromSpectrumIdentificationItems < ActiveRecord::Migration

  def change
    remove_timestamps :spectrum_identification_items
  end  
  
  
end
