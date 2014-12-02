$ ->
  $(document).ajaxStart (e) -> 
    $('#ajax-indicator').addClass 'on'
  $(document).ajaxStop (e) -> 
    $('#ajax-indicator').removeClass 'on'
  $(document).ajaxError (e) -> 
    alert e

  setTimeout ->
    $("#bootstrap_alerts .alert").fadeTo(3000, 0).slideUp(3000, -> $(this.remove()))
  ,3000

jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
