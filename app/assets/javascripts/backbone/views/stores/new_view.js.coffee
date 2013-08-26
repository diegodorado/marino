Marino.Views.Stores ||= {}

class Marino.Views.Stores.NewView extends Backbone.View
  template: JST["backbone/templates/stores/new"]

  events:
    "submit #new-store": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (store) =>
        @model = store
        window.location.hash = "/#{@model.id}"

      error: (store, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
