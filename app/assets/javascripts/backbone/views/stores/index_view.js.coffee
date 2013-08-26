Marino.Views.Stores ||= {}

class Marino.Views.Stores.IndexView extends Backbone.View
  template: JST["backbone/templates/stores/index"]

  initialize: () ->
    @options.stores.bind('reset', @addAll)

  addAll: () =>
    @options.stores.each(@addOne)

  addOne: (store) =>
    view = new Marino.Views.Stores.StoreView({model : store})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(stores: @options.stores.toJSON() ))
    @addAll()

    return this
