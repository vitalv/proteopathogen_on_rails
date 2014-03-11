# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("a[data-pdp-cvp-id]").click ->
    data_pdp_cvp_id = $(this).data("pdp-cvp-id")
    $("table").find("table[data-pdp-cvp-id='" + data_pdp_cvp_id + "']").toggle "fast" 
    return false;

$ ->
  $("a[data-pdp-up-id]").click ->
    data_pdp_up_id = $(this).data("pdp-up-id")
    $("table").find("table[data-pdp-up-id='" + data_pdp_up_id + "']").toggle "fast" 
    return false;
    

jQuery.extend jQuery.fn.dataTableExt.oSort,
  "natural-asc": (a, b) ->
    naturalSort a, b
  "natural-desc": (a, b) ->
    naturalSort(a, b) * -1
$ -> 
  $("#pag_table").dataTable
    sPaginationType: "full_numbers"
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#pag_table').data('source')
    aoColumns: [{sType: "natural"}, {bSortable: false}, {bSortable: false} ]
    #aaSorting: [[ 0, "asc" ]]
    fnInitComplete: (oSettings)->
      if oSettings._iDisplayLength > oSettings.fnRecordsDisplay()
        $(oSettings.nTableWrapper).find(".dataTables_paginate, .dataTables_length, .dataTables_filter").hide()
        $('thead th').unbind('click')
    fnDrawCallback: (oSettings) ->
      if oSettings._iDisplayLength > oSettings.fnRecordsDisplay()
        $(oSettings.nTableWrapper).find(".dataTables_paginate").hide()
      else
        $(oSettings.nTableWrapper).find(".dataTables_paginate, .dataTables_length").show() 
        
      $('table#pdh_table').find('tbody').html("<tr><td colspan='5' class='empty'>Protein detection hypothesis. Single result of the Protein Detection analysis</td></tr>")
      $("table#pdh_cvp").find('tbody').html("<tr><td class='empty'>PSI-MS CV terms, names and value</td></tr>")
      $("table#pdh_up").find('tbody').html("<tr><td class='empty'>PSI-MS CV terms, names and value</td></tr>")
      $('#protein_sequence').empty()
      $("#protein_sequence").append("<p>PROTEIN SEQUENCE</p>")
      $('table#psms_table').find('tbody').empty()
      return


$ ->
  $("#pag_table").on "click", ".pag_link", ()  ->
    $("#pag_table .flat_link").removeClass("flat_link")
    $(this).addClass("flat_link")
    $("#pdh_cvp td.empty").empty()
    #$("#protein_sequence").empty()
    $('#protein_sequence').empty()
    $("#protein_sequence").append("<p>PROTEIN SEQUENCE</p>")
    


$ ->  
  $('#pdh_table').on "click", ".pdh_link", (e) -> 
  #this function is bound to all ".sii_link" click events, even if they are added to the DOM via ajax later
    pdh_id = $(this).data("pdh-id")
    $("#pdh_table .flat_link").removeClass("flat_link")
    $(this).addClass("flat_link")
    $("#protein_sequence").empty()


$ ->
  $("#psms_table.dataTable").dataTable
	  bLengthChange: false
	  bFilter: false
	  bInfo: false
	  bPaginate: true
	  aoColumns: [{"sType": "natural"}, {"sType": "natural"} ]
    
