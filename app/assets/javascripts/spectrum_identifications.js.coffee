# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("a[data-sar-id]").click ->
    data_sar_id = $(this).data("sar-id")
    $("table").find("table[data-sar-id='" + data_sar_id + "']").toggle "fast" 
    return false
    
    
$ ->
  $("a[data-sip-id]").click ->
    data_sip_id = $(this).data("sip-id")
    $("table").find("table[data-sip-id='" + data_sip_id + "']").toggle "fast" 
    return false    

$ ->
  $("a[data-sip-cvp-id]").click ->
    data_sip_cvp_id = $(this).data("sip-cvp-id")
    $("table").find("table[data-sip-cvp-id='" + data_sip_cvp_id + "']").toggle "fast" 
    return false    
    
$ ->
  $("a[data-sip-up-id]").click ->
    data_sip_up_id = $(this).data("sip-up-id")
    $("table").find("table[data-sip-up-id='" + data_sip_up_id + "']").toggle "fast" 
    return false    

$ ->
  $("a[data-sip-mods-id]").click ->
    data_sip_mods_id = $(this).data("sip-mods-id")
    $("table").find("table[data-sip-mods-id='" + data_sip_mods_id + "']").toggle "fast" 
    return false    


$ ->
  $("#sip_mods.dataTable").dataTable(
	  "bLengthChange": false,
	  "bFilter": false,
	  "bInfo": false,
	  "bPaginate": false
  )
  
  #dataset = [5, 10, 15, 20, 25]
  ##dataset = $("spectrum_identification").data
  #d3.select("content").selectAll("p")
    #.data(dataset)
    #.enter()  
    #.append("p")
    #.text( (d) ->  return d ) #javascript: .text(function(d) { return d; });
  


  jsonCircles = [
    { "x_axis": 30, "y_axis": 30, "radius": 20, "color" : "green" },
    { "x_axis": 110, "y_axis": 110, "radius": 20, "color" : "red"},
    { "x_axis": 70, "y_axis": 70, "radius": 20, "color" : "purple"}
  ]
  
  jsonRectangles = [
    { "x_axis": 30, "y_axis": 30, "width": 18,  "height":20, "color" : "green" },
    { "x_axis": 110, "y_axis": 110, "width": 22,  "height":18, "color" : "red"},
    { "x_axis": 450, "y_axis": 70, "width": 20,  "height":22, "color" : "purple"}
  ]
 
##SpectrumIdentificationItem.find(24337).fragments.where(fragment_type: "frag: y ion").to_json
#jsonFragments = [
# {"id":228,"spectrum_identification_item_id":24337,"charge":1,"index":51,"m_mz":5632.88,"m_intensity":36810000,"m_error":0.0075,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"},
# {"id":229,"spectrum_identification_item_id":24337,"charge":1,"index":21,"m_mz":2411.3,"m_intensity":24380000,"m_error":-0.0042,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"},
# {"id":230,"spectrum_identification_item_id":24337,"charge":1,"index":5,"m_mz":521.271,"m_intensity":649000,"m_error":-0.0008,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"}
#]


##Dynamically Adjusting SVG Container Space:
  max_x = 0
  max_y = 0  
  
  i = 0
  while i < jsonRectangles.length
  
    temp_x = jsonRectangles[i].x_axis + jsonRectangles[i].width
    temp_y = jsonRectangles[i].y_axis + jsonRectangles[i].height
 
    max_x = temp_x  if temp_x >= max_x
    max_y = temp_y  if temp_y >= max_y
    i++

  max_x
  max_y
	  
  



  svgContainer = d3.select("content").append("svg")
                                  .attr("width", max_x + 20)
                                  .attr("height", max_y + 20)
                                  .style("border", "1px solid black");

  #circles = svgContainer.selectAll("circle")
  rectangles = svgContainer.selectAll("rect")
                        #.data(jsonCircles)
                        .data(jsonRectangles)
                        .enter()
                        .append("rect");

  #circleAttributes = circles
  rectangleAttributes = rectangles
                     #.attr("cx", (d) -> return d.x_axis)
                     .attr("x", (d) -> return d.x_axis)
                     #.attr("cy", (d) -> return d.y_axis)
                     .attr("y", (d) -> return d.y_axis)
                     #.attr("r",  (d) -> return d.radius)
                     .attr("width",  (d) -> return d.width)
                     .attr("height",  (d) -> return d.height)
                     .style("fill", (d) -> return d.color)
