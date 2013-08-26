Marino.Views.Crops ||= {}

class Marino.Views.Crops.EditView extends Backbone.View
  template: JST["backbone/templates/crops/edit"]

  events:
    "submit #edit-crop": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (crop) =>
        @model = crop
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
