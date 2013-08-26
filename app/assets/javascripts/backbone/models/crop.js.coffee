class Marino.Models.Crop extends Backbone.Model
  paramRoot: 'crop'

  defaults:
    name: null

class Marino.Collections.CropsCollection extends Backbone.Collection
  model: Marino.Models.Crop
  url: '/crops'
