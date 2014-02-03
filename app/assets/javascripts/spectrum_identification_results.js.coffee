# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 
#ready = -> 

$ -> 
  $("#sir_table").dataTable
    sPaginationType: "full_numbers"
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#sir_table').data('source')



# Note that if I use the "click" function on ".sii_link" like so:
#$ ->
#  $('a[data-sii-id]').click ->
# it does not trigger the js, since sii_link is not yet in the DOM, it is created ajaxy
#Remember that $ -> makes JQuery run the function on DOMContentLoaded
#And if I, instead, use:
#$ ->
#  $('#sii_table').on "click", ".sii_link", (e) ->
#the "on" function triggers an html response:
#In the network tab in chrome console, I see every time a click a sii_link two responses are triggered:
#one html and one (JS)
#I think it may need to trigger this additional html so the "on" funciton can parse the new ajax-created sii_link DOM node

#See delegated events : http://api.jquery.com/on/
#Delegated events have the advantage that they can process events from descendant elements that are added to the document at a later time

#this function, in show.js.erb works bad. Only for 2nd click and subsequents. Por que? No se sabe
$ ->
  $("#sir_table").on "click", ".sir_link", ()  ->
    $("#sir_table .flat_link").removeClass("flat_link")
    $(this).addClass("flat_link")
    $("#spectrum").empty()
    $("#peptide_sequence").remove()
    $("#sii_cvp td.empty").empty()

      
$ ->  
  $('#sii_table').on "click", ".sii_link", (e) -> 
  #this function is bound to all ".sii_link" click events, even if they are added to the DOM via ajax later
    sii_id = $(this).data("sii-id")

    $("#sii_table .flat_link").removeClass("flat_link")
    $(this).addClass("flat_link")

    $("#spectrum").empty()
    
    $("#peptide_sequence").remove()
    $("#spectrum").before("<div id=peptide_sequence class=spectrum_annotation>")
    

    d3.json "results/sir_id/identification_item?sii_id=" + sii_id + "", (error, json) ->
      $("#spectrum").css("visibility", "visible") 
      return console.warn(error) if error
      if $.isEmptyObject json
        missing_spec_msg = "<div class=spectrum_display_msg><p>NO FRAGMENTATION AVAILABLE FOR SELECTED SPECTRUM IDENTIFICATION ITEM</p></div>"
        $("#spectrum").append(missing_spec_msg)
      else
        visualizeD3spectrum json
    #e.preventDefault()


#visualizeD3spectrum = (json) ->
$ -> 

  #jsonFragmentIons = json
  jsonFragmentIons = [{"id":12769,"spectrum_identification_item_id":28223,"charge":1,"index":0,"m_mz":946.492,"m_intensity":46,"m_error":0.00656,"fragment_type":"frag: precursor ion - H2O","psi_ms_cv_fragment_type_accession":"MS:1001521"},{"id":12770,"spectrum_identification_item_id":28223,"charge":1,"index":9,"m_mz":918.52,"m_intensity":2,"m_error":0.029029,"fragment_type":"frag: a ion","psi_ms_cv_fragment_type_accession":"MS:1001229"},{"id":12771,"spectrum_identification_item_id":28223,"charge":1,"index":9,"m_mz":946.492,"m_intensity":46,"m_error":0.006119,"fragment_type":"frag: b ion","psi_ms_cv_fragment_type_accession":"MS:1001224"},{"id":12772,"spectrum_identification_item_id":28223,"charge":1,"index":9,"m_mz":929.542,"m_intensity":15,"m_error":0.082664,"fragment_type":"frag: b ion - NH3","psi_ms_cv_fragment_type_accession":"MS:1001232"},{"id":12773,"spectrum_identification_item_id":28223,"charge":1,"index":6,"m_mz":683.442,"m_intensity":6,"m_error":0.119497,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"},{"id":12774,"spectrum_identification_item_id":28223,"charge":1,"index":5,"m_mz":550.421,"m_intensity":1,"m_error":0.136,"fragment_type":"frag: y ion - NH3","psi_ms_cv_fragment_type_accession":"MS:1001233"},{"id":12775,"spectrum_identification_item_id":28223,"charge":1,"index":6,"m_mz":665.338,"m_intensity":2,"m_error":0.026057,"fragment_type":"frag: y ion - NH3","psi_ms_cv_fragment_type_accession":"MS:1001233"},{"id":12776,"spectrum_identification_item_id":28223,"charge":1,"index":9,"m_mz":946.492,"m_intensity":46,"m_error":0.006119,"fragment_type":"frag: y ion - NH3","psi_ms_cv_fragment_type_accession":"MS:1001233"},{"id":12777,"spectrum_identification_item_id":28223,"charge":1,"index":5,"m_mz":552.401,"m_intensity":5,"m_error":0.12416,"fragment_type":"frag: z ion","psi_ms_cv_fragment_type_accession":"MS:1001230"},{"id":12778,"spectrum_identification_item_id":28223,"charge":1,"index":7,"m_mz":764.39,"m_intensity":51,"m_error":0.033453,"fragment_type":"frag: z ion","psi_ms_cv_fragment_type_accession":"MS:1001230"}]

  i = 0
  while i < jsonFragmentIons.length
    if jsonFragmentIons[i].fragment_type.match(/precursor/)
      jsonFragmentIons[i].color = "darkgray"
    else if jsonFragmentIons[i].fragment_type.match(/frag: a/)
      jsonFragmentIons[i].color = "crimson"
    else if jsonFragmentIons[i].fragment_type.match(/frag: b/)
      jsonFragmentIons[i].color = "orangered"  
    else if jsonFragmentIons[i].fragment_type.match(/frag: c/)
      jsonFragmentIons[i].color = "darkorange"
    else if jsonFragmentIons[i].fragment_type.match(/frag: x/) 
     jsonFragmentIons[i].color = "teal" 
    else if jsonFragmentIons[i].fragment_type.match(/frag: y/)
     jsonFragmentIons[i].color = "royalblue"
    else if jsonFragmentIons[i].fragment_type.match(/frag: z/)
      jsonFragmentIons[i].color = "navy"
    else 
      jsonFragmentIons[i].color = "black"
    i++


  #SET UP svgContainer--------------------------------------------
  #---------------------------------------------------------------
  w = 600
  h = 280
  padding = 40
  #svgContainer = d3.select("#spectrum").append("svg")
  svgContainer = d3.select("#spectrum_test").append("svg")
                                     .attr("width", w)
                                     .attr("height", h)
                                     

  #SCALING thing--------------------------------------------------
  #---------------------------------------------------------------
  maxInitialMz = d3.max(jsonFragmentIons, (d) -> return d.m_mz)
  minInitialMz = d3.min(jsonFragmentIons, (d) -> return d.m_mz)  
  maxInitialIntensity = d3.max(jsonFragmentIons, (d) -> return d.m_intensity)
  minInitialIntensity = d3.min(jsonFragmentIons, (d) -> return d.m_intensity)
  
  xScale = d3.scale.linear() #Remember: When I say “input,” you say “domain.” Then I say “output,” and you say “range.” Ready?
                   .domain([minInitialMz, maxInitialMz])
                   .range([padding, w - padding])
                   #.range([padding, w]) 
                   .nice() # This tells the scale to take whatever input domain that you gave to range() and expand both ends to the nearest round value

  yScale = d3.scale.linear()
                   .domain([minInitialIntensity, maxInitialIntensity])
                   #.range([padding, h - padding])  #Now that we’re using scales, it’s super easy to reverse that, so greater values are higher up, as you would expect (alignedleft/scales)
                   .range([h - padding, padding])
                   .nice()

  #SET UP Axis----------------------------------------------------
  xAxis = d3.svg.axis()
                 .scale(xScale)
                 .orient("bottom")
                 .ticks(5)

  yAxis = d3.svg.axis()
                 .scale(yScale)
                 .orient("left")
                 .ticks(5)
                 #.tickFormat("")
                 
  
  #APEND, Axis, MS BARS , etc To svgContainer --------------------  
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
               

  msBars = svgContainer.selectAll('line.matched_peak')   
                        .data(jsonFragmentIons)
                        .enter()
                        .append("line")
                        .attr("class", "matched_peak")
                        .attr("x1", (d) -> return xScale(d.m_mz) )
                        .attr("y1", h - padding)
                        .attr("x2", (d) -> return xScale(d.m_mz) )
                        .attr("y2", (d) -> return  yScale(d.m_intensity) )
                        .attr("stroke-width", 1)
                        .attr("stroke", (d) -> return d.color)
                        .attr("fill")
                        

  msBarText = svgContainer.selectAll("text.matched_peak_label") #note I have to add class name, w/o it I would select DOM elements that the axis component added  From SO: "The problem is that you're drawing the axes before adding the lines and labels. By doing .selectAll("line") and .selectAll("text"), you're selecting the existing DOM elements that the axis component added. Then you're matching data to it and therefore your .enter() selection doesn't contain what you suppose."
                           .data(jsonFragmentIons)
                           .enter()
                           .append("text")
                           .attr("class", "matched_peak_label")
                           .attr("x", (d) -> return xScale(d.m_mz) )
                           .attr("y", (d) -> return yScale(d.m_intensity) )                     
                           .text((d) -> return d.fragment_type.substr(5)) #substr removes the "frag: " part
                           #.attr("transform", (d) -> return "rotate(90)" )
                           .attr("font-family", "sans-serif")
                           .attr("font-size", "9px")
                           #.attr("cursor", "pointer")
                           .attr("fill", "gray")


  #TOOLTIPS. 2 OPTIONS:
  #---------------------------------------------------------------
  #1 HTML div tooltips--------------
  #msBarTextLabels.on("mouseover", (d) ->  
  #  #Get this bar's x/y values, then augment for the tooltip
  #  xPosition = parseFloat(d3.select(this).attr("x")) #+ 300 #OJO No puedo usar rangeBand porque esa es una propiedad de las escalas ordinales !!+ xScale.rangeBand() / 2
  #  yPosition = parseFloat(d3.select(this).attr("y")) 
  #  #Update the tooltip position and value
  #  d3.select("#tooltip")
  #    .style("left", xPosition + "px")
  #    .style("top", yPosition + "px")
  #    .select("#value")
  #    .html(d.fragment_type + '<br/>z: ' + d.charge + '<br/>m/z: ' + d.m_mz + '<br/>intensity: ' + d.m_intensity + '<br/>error: ' + d.m_error)
  #  #Show the tooltip
  #  d3.select("#tooltip").classed("hidden", false)
  #
  #).on("mouseout",  (d) -> d3.select("#tooltip").classed("hidden",true) )

  #2 jquery plugin tipsy-------------- Include //= require jquery.tipsy in application.js
  $("svg line").tipsy
    gravity: "n"
    offset: 1
    html: true
    title: ->
      d = @__data__
      #c = colors(d.i)
      d.fragment_type + '<br/>z: ' + d.charge + '<br/>m/z: ' + d.m_mz + '<br/>intensity: ' + d.m_intensity + '<br/>error: ' + d.m_error
  

  #CHECKBOX Thing to filter (show only) checked ion types
  #d3.selectAll(".input class id").on "change", ->
  #  selected = this.name
  #  display = (if @checked then "inline" else "none")
    
  #  svgContainer.selectAll("line")
  #                                .filter( (d) -> d.fragment_type == selected )
  #                                .attr("display", display)
  
  
  
  
  
  #THE ZOOM THING ----------------------------------------------------------------
  zoomed = ->
  
    #translate = zoom.translate()
    #scale = zoom.scale()
    #tx = Math.min(0, Math.max(w * (1 - scale), translate[0]))
    #ty = Math.min(0, Math.max(h * (1 - scale), translate[1]))
    #zoom.translate([tx,ty])
    
    #t = d3.event.translate
    #s = d3.event.scale
    #t[0] = Math.min(w / 2 * (s - 1), Math.max(w / 2 * (1 - s), t[0]))
    #t[1] = Math.min(h / 2 * (s - 1) + 230 * s, Math.max(h / 2 * (1 - s) - 230 * s, t[1]))

    
    #zoom.translate t

    
  
    svgContainer.select("g.x.axis").call xAxis
    svgContainer.select("g.y.axis").call yAxis
    
    
    
    svgContainer.selectAll("line.matched_peak")
                            .attr("x1", (d) -> return xScale(d.m_mz) )
                            .attr("y1", h - padding)
                            .attr("x2", (d) -> return xScale(d.m_mz) )
                            .attr("y2", (d) -> return yScale(d.m_intensity) )
    svgContainer.selectAll("text.matched_peak_label")
                            .attr("x", (d) -> return xScale(d.m_mz) )
                            .attr("y", (d) -> return yScale(d.m_intensity) )


#The zoom behaviour listens to mouse events and modifies the range of the associated scales
#The scales are used by the axes which draw them as lines with ticks, 
#and the scales are also used by the data associated with my lines(peaks)
#So when the zoom changes, it fires a callback with the method defined in zoomed
#Buuut I don't want the default zoom behavior on the y scale.
#I want to modify the y scales domain myself whenever we get a zoom or pan

#    filtered_data =  
#      jsonFragmentIons.filter (d) ->
#        zoomed_mz = xScale(d.m_mz)
#        zoomed_mz > 0 and zoomed_mz < w

#    yExtent = -> d3.extent(filtered_data, (d) -> d.value)
    
    

#    zoom.y.domain(yExtent).nice()

 

  
  
  zoom = d3.behavior.zoom()
                     .x(xScale)
                     #.xExtent[0] = 0
                     .y(yScale)
                     #.scaleExtent([0, 10000])
                     #.yExtent[0] = 0
                     .on("zoom", zoomed)

  
  svgContainer.call zoom
  
  
#$(document).ready ready
#$(document).on "page:load", ready 

