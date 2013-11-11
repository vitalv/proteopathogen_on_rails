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
    #sAjaxSource: $('#sir_id_' + @sir_id)
    @sir_id = 19186
    #sAjaxSource: ('results/' + @sir_id )
    #sAjaxSource:$("a[sir_id]").data('source')
    #sAjaxSource: $('#sii_table').data('source')
    #bServerSide: true
    
    
$ ->
  $("a[sir_id]").click ->
    my_sii_datatable
      #sAjaxSource: ('results/' + @sir_id )
    #$("#sii_table").dataTable
      sAjaxSource: $('#sii_table').data('results/' + @sir_id )
      fnDraw()

#  sir_id = "#{@sir_id}"
#  $(socument).ready ->
#    sir_id = sir_id
#    alert sir_id

#$ -> 
#  $("#sii_table").html("hola que ase")
