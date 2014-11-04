$ ->
  $(document).ajaxStart (e) -> 
    $('#ajax-indicator').addClass 'on'
  $(document).ajaxStop (e) -> 
    $('#ajax-indicator').removeClass 'on'
  $(document).ajaxError (e) -> 
    alert e


jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()