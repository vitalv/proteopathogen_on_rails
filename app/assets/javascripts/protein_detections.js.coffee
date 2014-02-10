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
    aoColumns: [{sType: "natural"}, bSortable: false ]
    aaSorting: [[ 0, "asc" ]]



$ ->
  $("#pag_table").on "click", ".pag_link", ()  ->
    $("#pag_table .flat_link").removeClass("flat_link")
    $(this).addClass("flat_link")
    $("#pdh_cvp td.empty").empty()
    
    #$("#spectrum").empty()
    #$("#peptide_sequence").remove()
    #$("#sii_cvp td.empty").empty()
    

$ ->  
  $('#pdh_table').on "click", ".pdh_link", (e) -> 
  #this function is bound to all ".sii_link" click events, even if they are added to the DOM via ajax later
    pdh_id = $(this).data("pdh-id")

    $("#pdh_table .flat_link").removeClass("flat_link")
    $(this).addClass("flat_link")
