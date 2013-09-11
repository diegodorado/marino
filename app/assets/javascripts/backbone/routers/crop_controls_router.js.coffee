class Marino.Routers.CropControlsRouter extends Backbone.Router
  initialize: (options) ->
    @crop_controls = new Marino.Collections.CropControlsCollection()
    @crop_controls.reset options.crop_controls

    @stores = new Marino.Collections.StoresCollection()
    @stores.reset options.stores

    @crops = new Marino.Collections.CropsCollection()
    @crops.reset options.crops

    view = new Marino.Views.CropControls.FiltersView
      crop_controls: @crop_controls
      stores: @stores
      crops: @crops
    $("#filters").html(view.render().el)
    $('#switch-filter')['bootstrapSwitch']()

  routes:
    "new"      : "newCropControl"
    "index"    : "index"
    ":id/edit" : "edit"
    ".*"        : "index"

  newCropControl: ->
    @view = new Marino.Views.CropControls.NewView
      collection: @crop_controls
      crop_controls: @crop_controls
      stores: @stores
      crops: @crops
    $("#crop_controls").html(@view.render().el)

  index: ->
    @view = new Marino.Views.CropControls.IndexView
      crop_controls: @crop_controls
      stores: @stores
      crops: @crops
      
    $("#crop_controls").html(@view.render().el)

  edit: (id) ->
    crop_control = @crop_controls.get(id)
    @view = new Marino.Views.CropControls.EditView
      model: crop_control
      crop_controls: @crop_controls
      stores: @stores
      crops: @crops
    $("#crop_controls").html(@view.render().el)
