Marino.Views.Invoices ||= {}

class Marino.Views.Invoices.IndexView extends Backbone.View
  template: JST["backbone/templates/invoices/index"]

  initialize: () ->
    @options.invoices.bind('reset', @addAll)

  addAll: () =>
    @options.invoices.each(@addOne)

  addOne: (invoice) =>
    view = new Marino.Views.Invoices.InvoiceView({model : invoice})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(invoices: @options.invoices.toJSON() ))
    @addAll()

    return this
