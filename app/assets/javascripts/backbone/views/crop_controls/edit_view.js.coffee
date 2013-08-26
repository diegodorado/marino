Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.EditView extends Backbone.View
  template: JST["backbone/templates/crop_controls/new"]

  events:
    "submit form": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (crop_control) =>
        @model = crop_control
        #window.location.hash = "/#{@model.id}"
        window.location.hash = "/index"
        
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))
    @$('input.checkbox').prettyCheckable()

    this.$("form").backboneLink(@model)

    return this
