class Marino.Models.Invoice extends Backbone.Model
  paramRoot: 'invoice'
  idAttribute: '_id'


class Marino.Collections.InvoicesCollection extends Backbone.Collection
  model: Marino.Models.Invoice
  url: ->
    Routes.admin_invoices_path()
