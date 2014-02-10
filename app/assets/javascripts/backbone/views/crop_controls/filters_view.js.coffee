Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.FiltersView extends Backbone.View
  template: JST["backbone/templates/crop_controls/filters"]
  
  events:
    "change #store-filter" : "store_filter_changed"
    "change #crop-filter" : "crop_filter_changed"
    "switch-change #switch-filter" : "switch_filter_changed"
    "click #new_crop_control" : "new_crop_control_click"
    "click #excel_crop_control" : "excel_crop_control_click"

  initialize: () ->
    @options.crop_controls.params = 
      crop_id: @options.crops.first().id
      gestion: true



  switch_filter_changed: (ev, data) ->
    if data.value
      delete @options.crop_controls.params.gestion
      @options.crop_controls.params.contabilidad = true
    else
      delete @options.crop_controls.params.contabilidad
      @options.crop_controls.params.gestion = true
      
    @options.crop_controls.trigger('filters_changed')
    

  store_filter_changed: (ev) ->
    val = $(ev.target).val()
    #@$("#new_crop_control").addClass "disabled"
    switch val 
      when "add" then ev.preventDefault()
      when "all"  
        delete @options.crop_controls.params.store_id
        @options.crop_controls.trigger('filters_changed')
      else 
        @$("#new_crop_control").removeClass "disabled"
        @options.crop_controls.params.store_id = val
        @options.crop_controls.trigger('filters_changed')

     
  crop_filter_changed: (ev) ->
    val = $(ev.target).val()
    @options.crop_controls.params.crop_id = val
    @options.crop_controls.trigger('filters_changed')

  new_crop_control_click: (ev) ->
    window.location.hash = "new"
    
  excel_crop_control_click: (ev) ->
    window.location = "/crop_controls.xlsx"


  render: =>
    @$el.html(@template(stores: @options.stores.toJSON(), crops: @options.crops.toJSON() ))
    return this
    