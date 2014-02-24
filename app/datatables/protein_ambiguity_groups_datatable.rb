class ProteinAmbiguityGroupsDatatable
  #this is called from respond_to format.json render json in the protein_detections controller to generate the json

  delegate :params, :link_to, to: :@view

  def initialize(view, pags)
    @view = view
    @protein_ambiguity_groups = pags
  
  end

  def as_json(options = {}) 
  #as_json is triggered (and over-ridden here) (behind the scenes) by the render json: call in the controller
  #This will return all the data that DataTables expects including all the relevant rows from the database

   {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @protein_ambiguity_groups.count,
      iTotalDisplayRecords: pags.total_entries,
      aaData: data      
    }
  

  end

  private

  def data
    pags.map do |pag|
      [
        link_to( "#{pag.protein_ambiguity_group_id}", "protein_detections/#{pag.id}", remote: true, format: :js, :data => {'pag-id' => "#{pag.id}"}, class: "pag_link" ),
        pag.proteins_in_group
      ]
    end
  end

  def pags
    @pags ||= fetch_pags
  end

  def fetch_pags
    pags = @protein_ambiguity_groups.order("#{sort_column} #{sort_direction}")
    pags = pags.page(page).per_page(per_page)
    if params[:sSearch].present?
      pags = pags.where("protein_ambiguity_group_id like :search", search: "%#{params[:sSearch]}%")
    end
    pags
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[protein_ambiguity_group_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
  
end
