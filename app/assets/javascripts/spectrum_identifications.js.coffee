# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor

#The main jQuery function is the $() function (the jQuery function). If you pass DOM objects to this function, it returns jQuery objects, with jQuery functionality added to them
$ ->
  $("a[data-background-color]").click -> 
    backgroundColor = $(this).data("background-color")
    textColor = $(this).data("text-color")
    paintIt(this, backgroundColor, textColor)


$ ->
  $("a[data-sar-id]").click ->
    data_sar_id = $(this).data("sar-id")
    $("table").find("table[data-sar-id='" + data_sar_id + "']").toggle "fast" 
    return false
    
    
$ ->
  $("a[data-sip-id]").click ->
    data_sip_id = $(this).data("sip-id")
    $("table").find("table[data-sip-id='" + data_sip_id + "']").toggle "fast" 
    return false    

$ ->
  $("a[data-sip-cvp-id]").click ->
    data_sip_cvp_id = $(this).data("sip-cvp-id")
    $("table").find("table[data-sip-cvp-id='" + data_sip_cvp_id + "']").toggle "fast" 
    return false    
    
$ ->
  $("a[data-sip-up-id]").click ->
    data_sip_up_id = $(this).data("sip-up-id")
    $("table").find("table[data-sip-up-id='" + data_sip_up_id + "']").toggle "fast" 
    return false    

$ ->
  $("a[data-sip-mods-id]").click ->
    data_sip_mods_id = $(this).data("sip-mods-id")
    $("table").find("table[data-sip-mods-id='" + data_sip_mods_id + "']").toggle "fast" 
    return false    
