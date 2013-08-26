class Marino.Models.Store extends Backbone.Model
  paramRoot: 'store'

  defaults:
    name: null

class Marino.Collections.StoresCollection extends Backbone.Collection
  model: Marino.Models.Store
  url: '/stores'
