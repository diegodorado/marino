#todo: remove $ function wrapper
$ ->
  #override datepicker options


  $.datepicker._attachments = (input, inst) ->
    appendText = @_get(inst, "appendText")
    isRTL = @_get(inst, "isRTL")
    inst.append.remove()  if inst.append
    if appendText
      inst.append = $("<span class=\"" + @_appendClass + "\">" + appendText + "</span>")
      input[(if isRTL then "before" else "after")] inst.append
    input.unbind "focus", @_showDatepicker
    inst.trigger.remove()  if inst.trigger
    showOn = @_get(inst, "showOn")
    # pop-up date picker when in the marked field
    input.focus @_showDatepicker  if showOn is "focus" or showOn is "both"
    if showOn is "button" or showOn is "both" # pop-up date picker when button clicked
      buttonText = @_get(inst, "buttonText")
      buttonImage = @_get(inst, "buttonImage")

      #EDITED: icon-calendar instead of img      
      inst.trigger = $((if @_get(inst, "buttonImageOnly") then $("<i>").addClass("icon-calendar").addClass(@_triggerClass)
      else $("<button type=\"button\"></button>").addClass(@_triggerClass).html((if buttonImage is "" then buttonText else $("<i>").addClass("icon-calendar")    
      ))))
      #END EDITED
      
      input[(if isRTL then "before" else "after")] inst.trigger
      inst.trigger.click ->
        if $.datepicker._datepickerShowing and $.datepicker._lastInput is input[0]
          $.datepicker._hideDatepicker()
        else if $.datepicker._datepickerShowing and $.datepicker._lastInput isnt input[0]
          $.datepicker._hideDatepicker()
          $.datepicker._showDatepicker input[0]
        else
          $.datepicker._showDatepicker input[0]
        false

