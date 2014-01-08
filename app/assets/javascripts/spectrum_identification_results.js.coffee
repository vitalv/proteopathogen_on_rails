# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 
ready = -> 

#$ -> 

  $("#sir_table").dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#sir_table').data('source')


#$ ->
  
  # Convenience for forms or links that return HTML from a remote ajax call.
  #    The returned markup will be inserted into the element id specified.
  #     
  #$('a[data-update-target]').live "ajax:success", (evt, data) ->
  #  target = $(this).data("update-target")
  #  $("#" + target).html data

  #$('#sir_link').bind "ajax:success", (e, data, status, xhr) ->
  #  alert "Success!"
  #  $('#sii_table').append(xhr.responseText);

  #$("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
  #  alert "the sir was clicked"

#  $("a[data-sir-id]").click ->
#    #@sir_id = $(this).data("sir-id")
#    alert "whaaa"
#    $("sii_table").tbody.html("asf")
#    $("sii_table").tbody.toggle "fast" 
    
$(document).ready ready
$(document).on "page:change", ready 
 
