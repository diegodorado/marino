Marino.Views.Crops ||= {}

class Marino.Views.Crops.CropView extends Backbone.View
  template: JST["backbone/templates/crops/crop"]

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
