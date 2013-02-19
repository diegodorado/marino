$ ->
  $(document).ajaxStart (e) -> 
    $('#ajax-indicator').addClass 'on'
  $(document).ajaxStop (e) -> 
    $('#ajax-indicator').removeClass 'on'
  $(document).ajaxError (e) -> 
    console.log e
    alert e

