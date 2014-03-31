class Marino.Models.Crop extends Backbone.Model
  paramRoot: 'crop'
  idAttribute: '_id'


class Marino.Collections.CropsCollection extends Backbone.Collection
  model: Marino.Models.Crop
  url: ->
    Routes.crops_path()
