class SpectrumIdentificationItemsDatatable < AjaxDatatablesRails
  
  def initialize(view, sir_id)
    @sir_id = sir_id
    @model_name = SpectrumIdentificationItem
    @columns = [spectrum_identification_items.sii_id, spectrum_identification_items.calc_m2z, spectrum_identification_items.exp_m2z, spectrum_identification_items.rank, spectrum_identification_items.charge_state, spectrum_identification_items.pass_threshold]
    @searchable_columns = [spectrum_identification_items.sii_id, spectrum_identification_items.pass_threshold]
    super(view)
  end
  
private

    def data
      spectrum_identification_items.map do |spectrum_identification_item|
        [
          # comma separated list of the values for each cell of a table row
          spectrum_identification_item.sii_id,
          spectrum_identification_item.calc_m2z,
          spectrum_identification_item.exp_m2z,
          spectrum_identification_item.rank,
          spectrum_identification_item.charge_state,
          spectrum_identification_item.pass_threshold
        ]
      end
    end

    def spectrum_identification_items
      @spectrum_identification_items ||= fetch_records
    end

    def get_raw_records
      # insert query here
      @spectrum_identification_items = SpectrumIdentificationResult.find(@sir_id).spectrum_identification_items
    end
    
    def get_raw_record_count
      search_records(get_raw_records).count
    end
    
    # ==== Insert 'presenter'-like methods below if necessary
end

