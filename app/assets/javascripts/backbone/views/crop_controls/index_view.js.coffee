Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.IndexView extends Backbone.View
  template: JST["backbone/templates/crop_controls/index"]

  initialize: () ->
    @collection = @options.crop_controls
    @shadowCollection = @collection.clone()

    @listenTo @collection, "add", (model, collection, options) => @shadowCollection.add(model, options)
    @listenTo @shadowCollection, "remove", (model, collection, options) =>
      @collection.remove(model, options)
      @collection.trigger('filters_changed')
    @listenTo @collection, "reset", (collection, options) => 
      options = _.extend({reindex: true}, options || {})
      @shadowCollection.reset(collection.models) if (options.reindex) 

    @collection.bind('filters_changed', @filters_changed)
    @collection.trigger('filters_changed')

    @shadowCollection.bind('reset', @addAll)
    @shadowCollection.bind('add', @addOne)


  filters_changed: =>
    @shadowCollection.params = @collection.params
    models = @collection.calculate()
    @shadowCollection.reset models, {reindex: false}


  addAll: () =>
    @$("tbody").empty()
    @shadowCollection.each(@addOne)

  addOne: (crop_control) =>
    view = new Marino.Views.CropControls.CropControlView({model : crop_control})
    @$("tbody").append(view.render().el)


  render: =>
    @$el.html(@template())
    @addAll()
    $("#filters").show()
    return this
