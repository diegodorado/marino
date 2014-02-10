Marino.Views.Stores ||= {}

class Marino.Views.Stores.StoreView extends Backbone.View
  template: JST["backbone/templates/stores/store"]

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
