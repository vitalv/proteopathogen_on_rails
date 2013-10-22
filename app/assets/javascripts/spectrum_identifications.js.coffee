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
    { "x_axis": 110, "y_axis": 110, "radius": 20, "color" : "red"}]
    { "x_axis": 70, "y_axis": 70, "radius": 20, "color" : "purple"},

  svgContainer = d3.select("body").append("svg")
                                  .attr("width", 200)
                                  .attr("height", 200);

  circles = svgContainer.selectAll("circle")
                        .data(jsonCircles)
                        .enter()
                        .append("circle");

  circleAttributes = circles
                     .attr("cx", (d) -> return d.x_axis)
                     .attr("cy", (d) -> return d.y_axis)
                     .attr("r",  (d) -> return d.radius)
                     .style("fill", (d) -> return d.color)
