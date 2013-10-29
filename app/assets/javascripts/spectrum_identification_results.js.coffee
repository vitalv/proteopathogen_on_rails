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

    data_sir_id = $(this).data("sir-id")
    #$("#sii_table").toggle "fast" #NO quiero que aparezca sii_table, solo su contenido
    
  



$ ->
  $("#sii_table").dataTable
    bLengthChange: false
    bFilter: false
    bInfo: false
    bPaginate: false
    bProcessing: true
    #bServerSide: true
    #sAjaxSource: $('#sii_table').data('source')


  sir_id = "#{@sir_id}"
  $(socument).ready ->
    sir_id = sir_id
    alert sir_id
