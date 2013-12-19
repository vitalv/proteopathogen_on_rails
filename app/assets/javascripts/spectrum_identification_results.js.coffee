# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 
ready = -> 

  $("#sir_table").dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#sir_table').data('source')


  $("a[data-sir-id]").click ->
    #@sir_id = $(this).data("sir-id")
    alert "whaaa"
    $("sii_table").tbody.html("asf")
    $("sii_table").tbody.toggle "fast" 
    
$(document).ready ready
$(document).on "page:load", ready 
 
