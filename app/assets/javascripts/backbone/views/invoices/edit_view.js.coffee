Marino.Views.Invoices ||= {}

class Marino.Views.Invoices.EditView extends Backbone.View
  template: JST["backbone/templates/invoices/form"]

  events:
    "submit form": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (invoice) =>
        @model = invoice
        window.location.hash = "index"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
