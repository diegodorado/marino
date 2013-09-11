Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.EditView extends Backbone.View
  template: JST["backbone/templates/crop_controls/form"]

  events:
    "submit form": "update"
    'change select[name="tipo_doc"]': 'tipo_doc_changed'

  constructor: (options) ->
    super(options)
    @collection = @options.crop_controls
    
    
        
  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (crop_control) =>
        @model = crop_control
        #window.location.hash = "/#{@model.id}"
        window.location.hash = "/index"
        
    )

  tipo_doc_changed: () ->
    if @model.isEntrada()
      @$('input[name="entrada"]').prop "disabled", false
      @$('input[name="salida"]').prop "disabled", true
      @model.set 'salida', 0
    if @model.isSalida()
      @$('input[name="entrada"]').prop "disabled", true
      @$('input[name="salida"]').prop "disabled", false
      @model.set 'entrada', 0

  render: ->
    @$el.html @template
      crop_control: @model.toJSON()
      stores: @options.stores.toJSON()
      crops: @options.crops.toJSON()
      tipo_docs: @options.crop_controls.tipo_docs
    @$('input.checkbox').prettyCheckable()
    @tipo_doc_changed()  #trigger this on render

    this.$("form").backboneLink(@model)
    $("#filters").hide()

    return this