Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.IndexView extends Backbone.View
  template: JST["backbone/templates/crop_controls/index"]

  initialize: () ->
    @collection = @options.crop_controls
    @collection.bind('reset', @addAll)
    @shadowCollection = @collection.clone()

    @listenTo @collection, "add", (model, collection, options) => @shadowCollection.add(model, options)
    @listenTo @collection, "remove", (model, collection, options) =>
      @shadowCollection.remove(model, options)
      @collection.trigger('filters_changed')
    @listenTo @collection, "sort reset", (collection, options) => 
      options = _.extend({reindex: true}, options || {})
      @shadowCollection.reset(collection.models) if (options.reindex) 

    @collection.bind('filters_changed', @filters_changed)
    @collection.trigger('filters_changed')

  filters_changed: =>
    @shadowCollection.params = @collection.params
    models = @shadowCollection.calculate()
    @collection.reset models, {reindex: false}


  addAll: () =>
    @$("tbody").empty()
    @collection.each(@addOne)

  addOne: (crop_control) =>
    view = new Marino.Views.CropControls.CropControlView({model : crop_control})
    @$("tbody").append(view.render().el)


  render: =>
    @$el.html(@template())
    @addAll()
    return this
