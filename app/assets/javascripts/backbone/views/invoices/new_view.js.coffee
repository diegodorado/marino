Marino.Views.Invoices ||= {}

class Marino.Views.Invoices.NewView extends Backbone.View
  template: JST["backbone/templates/invoices/form"]

  events:
    "submit form": "save"

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
      success: (invoice) =>
        @model = invoice
        window.location.hash = "index"

      error: (invoice, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
