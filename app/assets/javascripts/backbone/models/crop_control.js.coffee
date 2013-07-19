class Marino.Models.CropControl extends Backbone.Model
  idAttribute: '_id'
  calculatedFields: ["saldo", "debe","haber","saldo_p"]

  defaults:
    gestion: true
    
  get: (key)->
    if key in @calculatedFields

      fecha = @get('fecha')
      previous = @collection.filter( (model) -> model.get('fecha') < fecha )
      sum = previous.reduce( (memo, model) ->
        model.get('entrada')-model.get('salida') + memo
      , 0 )
      sum
    else
      super(key)
    
class Marino.Collections.CropControlsCollection extends Backbone.Collection
  model: Marino.Models.CropControl
  url: '/crop_controls'


