class Marino.Routers.CropsRouter extends Backbone.Router
  initialize: (options) ->
    @crops = new Marino.Collections.CropsCollection()
    @crops.reset options.crops

  routes:
    "new"      : "newCrop"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newCrop: ->
    @view = new Marino.Views.Crops.NewView(collection: @crops)
    $("#crops").html(@view.render().el)

  index: ->
    @view = new Marino.Views.Crops.IndexView(crops: @crops)
    $("#crops").html(@view.render().el)

  show: (id) ->
    crop = @crops.get(id)

    @view = new Marino.Views.Crops.ShowView(model: crop)
    $("#crops").html(@view.render().el)

  edit: (id) ->
    crop = @crops.get(id)

    @view = new Marino.Views.Crops.EditView(model: crop)
    $("#crops").html(@view.render().el)
