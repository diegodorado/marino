Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.NewView extends Backbone.View
  template: JST["backbone/templates/crop_controls/new"]

  events:
    "submit form": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()
    @model.set @collection.params #sets filters

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (crop_control) =>
        @model = crop_control
        #window.location.hash = "/#{@model.id}"
        window.location.hash = "/index"

      error: (crop_control, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))
    @$('input.checkbox').prettyCheckable()
    @$("form").backboneLink(@model)
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