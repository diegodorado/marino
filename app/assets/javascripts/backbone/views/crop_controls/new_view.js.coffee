Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.NewView extends Backbone.View
  template: JST["backbone/templates/crop_controls/form"]

  events:
    "click .save_and_add": "save_and_add"
    "submit form": "save"
    'change select[name="tipo_doc"]': 'tipo_doc_changed'

  constructor: (options) ->
    super(options)
    @collection = @options.crop_controls
    @initModel()
    
  initModel: () ->
    if @model
      @model = @model.clone()
      @model.set 
        entrada: 0
        salida: 0
    else
      @model = new @collection.model()
      @model.set @collection.params #sets filters
      @model.set 
        precio_unitario: @collection.precio_unitario()
        fecha: (new Date).toJSON().substring(0, 10)

    @model.bind("change:errors", () =>
      this.render()
    )


  save: (e) ->
    e.preventDefault()

    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (crop_control) =>
        @model = crop_control
        #window.location.hash = "/#{@model.id}"
        window.location.hash = "index"

      error: (crop_control, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  save_and_add: (e) ->
      e.preventDefault()

      e.stopPropagation()

      @model.unset("errors")

      @collection.create(@model.toJSON(),
        success: (crop_control) =>
          @initModel()
          @render()

        error: (crop_control, jqXHR) =>
          @model.set({errors: $.parseJSON(jqXHR.responseText)})
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

