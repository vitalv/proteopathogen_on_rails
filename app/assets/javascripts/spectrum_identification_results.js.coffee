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
  my_sii_datatable = $("#sii_table").dataTable
    bLengthChange: false
    bFilter: false
    bInfo: false
    bPaginate: false
    bProcessing: true
    
    
    
$ ->
  $("a[data-sir-id]").click ->
    data_sir_id = $(this).data("sir-id")
    my_sii_datatable
      #sAjaxSource: ('results/' + @sir_id )
      sAjaxSource: ('results/' + data_sir_id )
    #$("#sii_table").dataTable
      #sAjaxSource: $('#sii_table').data('source' )
      fnDraw()

#  sir_id = "#{@sir_id}"
#  $(socument).ready ->
#    sir_id = sir_id
#    alert sir_id

#$ -> 
#  $("#sii_table").html("hola que ase")
