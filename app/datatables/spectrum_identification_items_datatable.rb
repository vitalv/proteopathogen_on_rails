class SpectrumIdentificationItemsDatatable < AjaxDatatablesRails
  
  def initialize(view)
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
        ]
      end
    end

    def spectrum_identification_items
      @spectrum_identification_items ||= fetch_records
    end

    def get_raw_records
      # insert query here
    end
    
    def get_raw_record_count
      search_records(get_raw_records).count
    end
    
    # ==== Insert 'presenter'-like methods below if necessary
end

