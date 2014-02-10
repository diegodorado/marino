Marino.Views.Crops ||= {}

class Marino.Views.Crops.IndexView extends Backbone.View
  template: JST["backbone/templates/crops/index"]

  initialize: () ->
    @options.crops.bind('reset', @addAll)

  addAll: () =>
    @options.crops.each(@addOne)

  addOne: (crop) =>
    view = new Marino.Views.Crops.CropView({model : crop})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(crops: @options.crops.toJSON() ))
    @addAll()

    return this
