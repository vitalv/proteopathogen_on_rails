class SpectrumIdentificationResultsDatatable
  #this is called from respond_to format.json render json in the spectrum_identification_results controller to generate the json

  delegate :params, :link_to, to: :@view

  def initialize(view, spectrum_identification_results)
    @view = view
    @spectrum_identification_results = spectrum_identification_results
  end

  def as_json(options = {}) 
  #as_jason is triggered (and over-ridden here) (behind the scenes) by the render json: call in the controller
  #This will return all the data that DataTables expects including all the relevant rows from the database

   {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @spectrum_identification_results.count,
      iTotalDisplayRecords: sirs.total_entries,
      aaData: data
    }
  

  end

  private

  def data
    sirs.map do |sir|
      [
        link_to( "#{sir.sir_id}", "results/#{sir.id}", :data => {'sir-id' => "#{sir.id}"}, remote: true ),
        #link_to( "#{sir.sir_id}", "#", :data => {'sir-id' => "#{sir.id}"}, remote: true ),
        sir.spectrum_name,
        sir.spectrum_id
      ]
    end
  end

  def sirs
    @sirs ||= fetch_sirs
  end

  def fetch_sirs
    sirs = @spectrum_identification_results.order("#{sort_column} #{sort_direction}")
    sirs = sirs.page(page).per_page(per_page)
    if params[:sSearch].present?
      sirs = sirs.where("spectrum_name like :search or sir_id or spectrum_id like :search", search: "%#{params[:sSearch]}%")
    end
    sirs
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[sir_id spectrum_name spectrum_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
  
end
