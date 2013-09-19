# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  $("a[data-sir-id]").click  ->
    #window.location = $(this).find('a').attr('href')
    #window.location = this.dataset.link
    #window.location = $(this).data("sir-id")
    sir_id = $(this).data("sir-id")
  

//~ $ ->
  //~ $(document).on 'click', 'tr[data-sir-id]', (evt) -> 
    //~ window.location = this.dataset.link
$ ->
  $("a[data-sar-id]").click ->
    data_sar_id = $(this).data("sar-id")
    $("table").find("table[data-sar-id='" + data_sar_id + "']").toggle "fast" 
    return false
    
    
