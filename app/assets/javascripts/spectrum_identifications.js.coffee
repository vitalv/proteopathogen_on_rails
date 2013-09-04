# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#this is vanilla javascript:
#function showhide(targetID) {
#		//change target element mode
#		var elementmode = document.getElementById(targetID).style;
#		elementmode.display = (!elementmode.display) ? 'none' : '';
#	}

#function changetext(changee,oldText,newText) {
#	//changes text in source element
#	var elementToChange = document.getElementById(changee);
#	elementToChange.innerHTML = (elementToChange.innerHTML == oldText) ? newText : oldText;
#}

#function workforchange(targetID,sourceID,oldContent,newContent) {
#	showhide(targetID);
#	changetext(sourceID,oldContent,newContent);
#}


#and this is coffeescript

#showhide = (targetID) -> 
#  elementmode = document.getElementById(targetID).style
#  elementmode.display = (!elementmode.display) ? 'none' : ''


#changetext = (changee,oldText,newText) ->
#  elementToChange = document.getElementById(changee)
#  elementToChange.innerHTML = (elementToChange.innerHTML == oldText) ? newText : oldText

#workforchange = (targetID,sourceID,oldContent,newContent) ->
#  showhide(targetID)
#  changetext(sourceID,oldContent,newContent)


@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor

