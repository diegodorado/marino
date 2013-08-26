Marino.Views.Stores ||= {}

class Marino.Views.Stores.ShowView extends Backbone.View
  template: JST["backbone/templates/stores/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
