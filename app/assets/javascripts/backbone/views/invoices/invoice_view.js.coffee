Marino.Views.Invoices ||= {}

class Marino.Views.Invoices.InvoiceView extends Backbone.View
  template: JST["backbone/templates/invoices/invoice"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    if (confirm('Está seguro de querer eliminar este registro?'))
      @model.destroy()
      @remove()
    
    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
