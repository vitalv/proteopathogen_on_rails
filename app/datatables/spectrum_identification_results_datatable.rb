class SpectrumIdentificationResultsDatatable
  #this is called from respond_to format.json render json in the spectrum_identification_results controller to generate the json

  delegate :params, :link_to, to: :@view

  def initialize(view, spectrum_identification_results)
    @view = view
    @spectrum_identification_results = spectrum_identification_results
  end

  def as_json(options = {}) 
  #as_json is triggered (and over-ridden here) (behind the scenes) by the render json: call in the controller
  #This will return all the data that DataTables expects including all the relevant rows from the database

   {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @spectrum_identification_results.count,
      iTotalDisplayRecords: sirs.total_entries,
      #iTotalDisplayRecords: @total_entries,
      aaData: data,

    }
  

  end

  private

  def data
    sirs.map do |sir|
      [
        link_to( "#{sir.sir_id}", "results/#{sir.id}", remote: true, format: :js, :data => {'sir-id' => "#{sir.id}"}, class: "sir_link" ),
        #link_to( "#{sir.sir_id}", action: :show, sir_id: sir.id, remote: true, format: :js, id: "sir_link" ),
        sir.spectrum_name||sir.spectrum_title,
        sir.spectrum_id
      ]
    end
  end

  def sirs
    @sirs ||= fetch_sirs
  end


  def fetch_sirs
    #sirs = @spectrum_identification_results.order("#{sort_column} #{sort_direction}") #("sir_id " "asc")
    
    if params[:iSortCol_0] == "0"
      
      ##sirs = custom_sort(sort_attr)
    
      sorted_sirs = @spectrum_identification_results.sort_by {|r| r.sir_id.split(/(\d+)/).map { |a| a=~ /\d+/ ? a.to_i : a } }
      sorted_sir_ids = sorted_sirs.collect { |sir| sir.id }
      if params[:sSortDir_0] == "asc"
        sirs = SpectrumIdentificationResult.where(id: sorted_sir_ids).order("field(id,#{sorted_sir_ids.join(',')})")
      elsif params[:sSortDir_0] == "desc"
        sirs = SpectrumIdentificationResult.where(id: sorted_sir_ids).order("field(id,#{sorted_sir_ids.reverse.join(',')})")
      end
      sirs = sirs.page(page).per_page(per_page)

    elsif params[:iSortCol_0].to_i == 2 
    
      sorted_sirs = @spectrum_identification_results.sort_by {|r| r.spectrum_id.split(/(\d+)/).map { |a| a=~ /\d+/ ? a.to_i : a } }
      sorted_sir_ids = sorted_sirs.collect { |sir| sir.id }
      if params[:sSortDir_0] == "asc"
        sirs = SpectrumIdentificationResult.where(id: sorted_sir_ids).order("field(id,#{sorted_sir_ids.join(',')})")
      elsif params[:sSortDir_0] == "desc"
        sirs = SpectrumIdentificationResult.where(id: sorted_sir_ids).order("field(id,#{sorted_sir_ids.reverse.join(',')})")
      end
      sirs = sirs.page(page).per_page(per_page)

    elsif params[:iSortCol_0].to_i == 1
    
      sorted_sirs = @spectrum_identification_results.sort_by do |r|
        spec = r.spectrum_name || r.spectrum_title
        spec.split(/(\d+)/).map { |a| a=~ /\d+/ ? a.to_i : a } 
      end
      sorted_sir_ids = sorted_sirs.collect { |sir| sir.id }
      if params[:sSortDir_0] == "asc"
        sirs = SpectrumIdentificationResult.where(id: sorted_sir_ids).order("field(id,#{sorted_sir_ids.join(',')})")
      elsif params[:sSortDir_0] == "desc"
        sirs = SpectrumIdentificationResult.where(id: sorted_sir_ids).order("field(id,#{sorted_sir_ids.reverse.join(',')})")
      end
      sirs = sirs.page(page).per_page(per_page)
      
    end
    
    sirs = sirs.page(page).per_page(per_page)
    
    if params[:sSearch].present?
      sirs = sirs.where("spectrum_name like :search or sir_id like :search or spectrum_id like :search", search: "%#{params[:sSearch]}%")
    end
    
    sirs
    
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end
  
  ##sort_attr = nil
  #def custom_sort (sort_attr = 'sir_id')
    #sort_attr = sort_attr
    #sorted_sirs = @spectrum_identification_results.sort_by {|r| r.sort_attr.split(/(\d+)/).map { |a| a=~ /\d+/ ? a.to_i : a } }
    #sorted_sir_ids = sorted_sirs.collect { |sir| sir.id }
    #if params[:sSortDir_0] == "asc"
      #sirs = SpectrumIdentificationResult.where(id: sorted_sir_ids).order("field(id,#{sorted_sir_ids.join(',')})")
    #elsif params[:sSortDir_0] == "desc"
      #sirs = SpectrumIdentificationResult.where(id: sorted_sir_ids).order("field(id,#{sorted_sir_ids.reverse.join(',')})")
    #end
    #sirs
  #end
  
  
  #def sort_column
  #  columns = %w[sir_id spectrum_name spectrum_id]
  #  columns[params[:iSortCol_0].to_i]
  #end

  #def sort_direction
  #  params[:sSortDir_0] == "desc" ? "desc" : "asc"
  #end

  
end



