class Marino.Models.Store extends Backbone.Model
  paramRoot: 'store'
  idAttribute: '_id'

class Marino.Collections.StoresCollection extends Backbone.Collection
  model: Marino.Models.Store
  url: '/stores'
