Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.FiltersView extends Backbone.View
  template: JST["backbone/templates/crop_controls/filters"]
  
  events:
    "change #store-filter" : "store_filter_changed"
    "change #crop-filter" : "crop_filter_changed"
    "switch-change #switch-filter" : "switch_filter_changed"
    "click #new_crop_control" : "new_crop_control_click"
    "click #excel_crop_control" : "excel_crop_control_click"
    "click #switch-filter-button" : "switch_filter_button_click"

  initialize: () ->
    @options.crop_controls.params = 
      crop_id: @options.crops.first().id
      gestion: true


  switch_filter_button_click: (ev) ->
    console.log $('#switch-filter-button').buttons()
    @$('input:radio').attr('checked', true);
    console.log @$(':input:checked').val()

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
    switch val
      when "all"  
        delete @options.crop_controls.params.store_id
        @options.crop_controls.trigger('filters_changed')
      else
        @options.crop_controls.params.store_id = val
        @options.crop_controls.trigger('filters_changed')

     
  crop_filter_changed: (ev) ->
    val = $(ev.target).val()
    @options.crop_controls.params.crop_id = val
    @options.crop_controls.trigger('filters_changed')

  new_crop_control_click: (ev) ->
    window.location.hash = "new"
    
  excel_crop_control_click: (ev) ->
    p = @options.crop_controls.params
    title = if p.contabilidad then "Contabilidad"  else "Gestion"
    title += "  -  #{@$('#store-filter :selected').text()} - #{@$('#crop-filter :selected').text()}"
    data = 
      title: title
      ids: @options.crop_controls.filteredIds()
      authenticity_token: $('meta[name=csrf-token]').attr('content')
    $.form(Routes.excel_crop_controls_path(), data , 'POST').submit()

  render: =>
    @$el.html(@template(stores: @options.stores.toJSON(), crops: @options.crops.toJSON() ))
    return this
    
