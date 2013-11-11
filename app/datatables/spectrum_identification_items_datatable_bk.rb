class SpectrumIdentificationItemsDatatable
  #this is called from respond_to format.json render json in the spectrum_identification_results controller to generate the json

  delegate :params, :link_to, to: :@view

  def initialize(view, spectrum_identification_items)
    @view = view
    @spectrum_identification_items = spectrum_identification_items
  end

  def as_json(options = {}) 
  #as_jason is triggered (and over-ridden here) (behind the scenes) by the render json: call in the controller
  #This will return all the data that DataTables expects including all the relevant rows from the database
   {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @spectrum_identification_items.count,
      iTotalDisplayRecords: siis.total_entries,
      aaData: data
    }
  end

  private

  def data
    siis.map do |sii|
      [
        sii.sii_id,
        sii.calc_m2z,
        sii.exp_m2z,
        sii.rank,
        sii.charge_state,
        sii.pass_threshold
      ]
    end
  end

  def siis
    @siis ||= fetch_siis
  end

  def fetch_siis
    siis = @spectrum_identification_items.order("#{sort_column} #{sort_direction}")
    siis = siis.page(page).per_page(per_page)
    #if params[:sSearch].present?
    #  siis = siis.where("sii_id like :search", search: "%#{params[:sSearch]}%")
    #end
    siis
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[sii_id calc_m2z exp_m2z rank charge_state pass_threshold]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
  
end

