Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.CropControlView extends Backbone.View
  template: JST["backbone/templates/crop_controls/crop_control"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()
    

    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
