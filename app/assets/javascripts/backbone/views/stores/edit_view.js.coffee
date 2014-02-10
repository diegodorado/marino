Marino.Views.Stores ||= {}

class Marino.Views.Stores.EditView extends Backbone.View
  template: JST["backbone/templates/stores/edit"]

  events:
    "submit #edit-store": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (store) =>
        @model = store
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
