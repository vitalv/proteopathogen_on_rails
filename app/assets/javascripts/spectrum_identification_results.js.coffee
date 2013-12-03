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


#$ ->
#  my_sii_datatable = $("#sii_table").dataTable
#    bLengthChange: false
#    bFilter: false
#    bInfo: false
#    bPaginate: false
#    bProcessing: true
#   # sAjaxSource:  ('results/' + data_sir_id )
    

$ ->
  $("a[data-sir-id]").click ->
#    #alert("whaa?!")
    @sir = $(this).data("sir-id")
    #fnDraw()
