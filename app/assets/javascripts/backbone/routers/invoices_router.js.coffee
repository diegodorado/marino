class Marino.Routers.InvoicesRouter extends Backbone.Router
  initialize: (options) ->
    @invoices = new Marino.Collections.InvoicesCollection()
    @invoices.reset options.invoices

  routes:
    "new"      : "newInvoice"
    "index"    : "index"
    ":id/pdf"  : "pdf"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"

  newInvoice: ->
    @view = new Marino.Views.Invoices.NewView(collection: @invoices)
    $("#invoices").html(@view.render().el)

  index: ->
    @view = new Marino.Views.Invoices.IndexView(invoices: @invoices)
    $("#invoices").html(@view.render().el)

  show: (id) ->
    invoice = @invoices.get(id)

    @view = new Marino.Views.Invoices.ShowView(model: invoice)
    $("#invoices").html(@view.render().el)

  edit: (id) ->
    invoice = @invoices.get(id)

    @view = new Marino.Views.Invoices.EditView(model: invoice)
    $("#invoices").html(@view.render().el)

  pdf: (id) ->
    url = Routes.get_pdf_admin_invoice_path(id)
    window.open url
