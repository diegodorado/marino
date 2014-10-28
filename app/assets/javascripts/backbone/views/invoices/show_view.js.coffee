Marino.Views.Crops ||= {}

class Marino.Views.Crops.ShowView extends Backbone.View
  template: JST["backbone/templates/crops/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
