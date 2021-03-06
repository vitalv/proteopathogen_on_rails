# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("a[data-exp-id]").click ->
    data_exp_id = $(this).data("exp-id")
    $("#protocol[data-exp-id='" + data_exp_id + "']").toggle "fast"
    return false;


jQuery.extend jQuery.fn.dataTableExt.oSort,
  "natural-asc": (a, b) ->
    naturalSort a, b
  "natural-desc": (a, b) ->
    naturalSort(a, b) * -1

$ ->
  $("#exp_mzid_files_table.dataTable").dataTable
    bLengthChange: false
    bFilter: false
    bInfo: false
    bPaginate: false
    aoColumns: [{bSortable: true},{bSortable: true}, {bSortable: false}, {bSortable: false}, {bSortable: false} ]

  return false;


$ ->
  $("#index_exp_table.dataTable").dataTable
    bLengthChange: true
    bFilter: true
    bInfo: true
    bPaginate: true
    aoColumns: [{"sType": "natural"}, {"sType": "natural"},{"sType": "date"},{"sType": "natural"} ]

    
