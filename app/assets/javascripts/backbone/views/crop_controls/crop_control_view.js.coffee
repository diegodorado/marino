Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.CropControlView extends Backbone.View
  template: JST["backbone/templates/crop_controls/crop_control"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    if (confirm('Está seguro de querer eliminar este registro?'))
      @model.destroy()
      @remove()
    

    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
