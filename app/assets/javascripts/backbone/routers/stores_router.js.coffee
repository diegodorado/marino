class Marino.Routers.StoresRouter extends Backbone.Router
  initialize: (options) ->
    @stores = new Marino.Collections.StoresCollection()
    @stores.reset options.stores

  routes:
    "new"      : "newStore"
    "index"    : "index"
    ":id/edit" : "edit"
    ".*"        : "index"

  newStore: ->
    @view = new Marino.Views.Stores.NewView(collection: @stores)
    $("#stores").html(@view.render().el)

  index: ->
    @view = new Marino.Views.Stores.IndexView(stores: @stores)
    $("#stores").html(@view.render().el)

  edit: (id) ->
    store = @stores.get(id)

    @view = new Marino.Views.Stores.EditView(model: store)
    $("#stores").html(@view.render().el)
