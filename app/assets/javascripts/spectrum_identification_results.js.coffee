# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#sir_table").dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#sir_table').data('source')


$ ->
  $("a[data-sir-id]").click ->
    @clicked_sir_id = $(this).data("sir-id")
    #$("sii_table").toggle "fast" #No quiero que aparezca y desaparezca, solo rellenarla con los siis corespondientes al sir
    
    return false


$ ->
  $("#sii_table").dataTable
    bLengthChange: false
    bFilter: false
    bInfo: false
    bPaginate: false
    bProcessing: true
    #bServerSide: true
    #sAjaxSource: $('#sii_table').data('source')






