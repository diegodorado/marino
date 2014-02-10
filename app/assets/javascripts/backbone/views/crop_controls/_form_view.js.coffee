Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.FormView extends Backbone.View
  template: JST["backbone/templates/crop_controls/form"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    @$('input.checkbox').prettyCheckable()

    this.$("form").backboneLink(@model)

    return this


  fecha_changed: (e) ->
    e.preventDefault()
    date = $(e.target).val()
    return unless date
    return
    
    $.getJSON("/crops/get_price",
      month: date[0..6]
      crop_id: @$(".crop-filter").val() 
    ).done((json) =>
      @$("input[name=precio_unitario]").val(json) 
    ).fail (jqxhr, textStatus, error) ->
      err = textStatus + ", " + error
      console.log "Request Failed: " + err