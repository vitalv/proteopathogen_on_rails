# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 
#ready = -> 

$ -> 
  $("#sir_table").dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#sir_table').data('source')


#  $("a[data-sar-id]").click ->
#    data_sar_id = $(this).data("sar-id")

#console.log gon.sii_url if gon
#Esto funciona:
#d3.json("results/24334/identification_item?sii_id=24337", function(error,json) { data = json; } );

$ ->
  $('a[data-sii-id]').click ->
    #d3.json gon.sii_url, (error, json) ->
    sii_id = $(this).data("sii-id")
    d3.json "results/sir_id/identification_item?sii_id=" + sii_id + "", (error, json) ->
      return console.warn(error) if error
      visualizeD3spectrum json


visualizeD3spectrum = (json) ->

  jsonFragmentIons = json

  i = 0
  while i < jsonFragmentIons.length
    if jsonFragmentIons[i].fragment_type == "frag: c ion"
      jsonFragmentIons[i].color = "steelblue"
    else if jsonFragmentIons[i].fragment_type == "frag: z+1 ion"
     jsonFragmentIons[i].color = "red" 
    else if jsonFragmentIons[i].fragment_type == "frag: y ion"
      jsonFragmentIons[i].color = "orange"
    i++



  #SET UP svgContainer--------------------------------------------
  #---------------------------------------------------------------
  w = 650
  h = 350
  padding = 40
  svgContainer = d3.select("#spectrum").append("svg")
                                     .attr("width", w)
                                     .attr("height", h)
                                     #.call(zoom)

  #SCALING thing--------------------------------------------------
  #---------------------------------------------------------------
  maxInitialMz = d3.max(jsonFragmentIons, (d) -> return d.m_mz)
  minInitialMz = d3.min(jsonFragmentIons, (d) -> return d.m_mz)  
  maxInitialIntensity = d3.max(jsonFragmentIons, (d) -> return d.m_intensity)
  minInitialIntensity = d3.min(jsonFragmentIons, (d) -> return d.m_intensity)
  
  xScale = d3.scale.linear() #Remember: When I say “input,” you say “domain.” Then I say “output,” and you say “range.” Ready?
                   .domain([minInitialMz, maxInitialMz])
                   .range([padding, w - padding]) 

  yScale = d3.scale.linear()
                   .domain([minInitialIntensity, maxInitialIntensity])
                   .range([padding, h - padding])  #Now that we’re using scales, it’s super easy to reverse that, so greater values are higher up, as you would expect (alignedleft/scales)
                   #.range([h - padding, padding])

  #SET UP Axis----------------------------------------------------
  #---------------------------------------------------------------
  xAxis = d3.svg.axis()
                 .scale(xScale)
                 .orient("bottom")
                 .ticks(5)

  yAxis = d3.svg.axis()
                 .scale(yScale)
                 .orient("left")
                 .ticks(5)
                 .tickFormat((d) -> '')
                 
                 
  
  #APEND, Axis, MS BARS , etc To svgContainer --------------------
  #---------------------------------------------------------------

  svgContainer.append("g")
               .attr("class", "x axis")
               .attr("transform", "translate(0," + (h - padding) + ")")
               .call(xAxis)

  svgContainer.append("g")
               .attr("class", "y axis")
               .attr("transform", "translate(" + padding  + ",0)")
               .call(yAxis)
              
  svgContainer.append("text")
               .attr("class", "xAxisLabel")
               .attr("text-anchor", "end")
               .attr("x", w - padding)
               .attr("y", h - 10)
               .text("m / z")
               .attr("font-family", "sans-serif")
               .attr("font-size", "12px")
  
  msBars = svgContainer.selectAll('line')
                        .data(jsonFragmentIons)
                        .enter()
                        .append("line")
                           
  msBarText = svgContainer.selectAll("text")
                           .data(jsonFragmentIons)
                           .enter()
                           .append("text")

  msBarAttributes = msBars
                     #.attr("y", (d) -> return h - yScale(d.m_intensity) )
                     #.attr("x", (d) -> return xScale(d.m_mz))
                     .attr("x1", (d) -> return xScale(d.m_mz) )
                     .attr("y1", h - padding)
                     .attr("x2", (d) -> return xScale(d.m_mz) )
                     .attr("y2", (d) -> return h - yScale(d.m_intensity) )
                     .attr("stroke-width", 1.2)
                     .attr("stroke", (d) -> return d.color)
                     #.attr("width", 2)
                     #.attr("fill")
                     
  msBarTextLabels = msBarText
                     .attr("x", (d) -> return xScale(d.m_mz) )
                     .attr("y", (d) -> return h - yScale(d.m_intensity) )
                     #.attr("transform", "rotate(90)")
                     #.text((d) -> return d.fragment_type.replace("frag:",'')
                     .text((d) -> return d.fragment_type.substr(5))
                     .attr("font-family", "sans-serif")
                     .attr("font-size", "9px")
                     .attr("cursor", "pointer")
                     .attr("fill", "gray")


  #TOOLTIPS. 2 OPTIONS:
  #---------------------------------------------------------------
  #1 HTML div tooltips--------------
  msBarTextLabels.on("mouseover", (d) ->  
    #Get this bar's x/y values, then augment for the tooltip
    xPosition = parseFloat(d3.select(this).attr("x")) + 300 #OJO No puedo usar rangeBand porque esa es una propiedad de las escalas ordinales !!+ xScale.rangeBand() / 2
    yPosition = parseFloat(d3.select(this).attr("y")) 
    #Update the tooltip position and value
    d3.select("#tooltip")
      .style("left", xPosition + "px")
      .style("top", yPosition + "px")
      .select("#value")
      .html(d.fragment_type + '<br/>z: ' + d.charge + '<br/>m/z: ' + d.m_mz + '<br/>intensity: ' + d.m_intensity + '<br/>error: ' + d.m_error)
    #Show the tooltip
    d3.select("#tooltip").classed("hidden", false)
  
  ).on("mouseout",  (d) -> d3.select("#tooltip").classed("hidden",true) )


#2 jquery plugin tipsy-------------- Include //= require jquery.tipsy in application.js

#  $("svg line").tipsy
#    gravity: "n"
#    offset: 1
#    html: true
#    title: ->
#      d = @__data__
#      #c = colors(d.i)
#      d.fragment_type + "<br/>m/z: " + d.m_mz + "<br/z: " + d.charge + "<br/>intensity: " + d.m_intensity 
      
      
  #CHECKBOX Thing to filter (show only) checked ion types
  d3.selectAll(".input class id").on "change", ->
    selected = this.name
    display = (if @checked then "inline" else "none")
    
    svgContainer.selectAll("line")
                                  .filter( (d) -> d.fragment_type == selected )
                                  .attr("display", display)
  

  
  
#$(document).ready ready
#$(document).on "page:load", ready 
