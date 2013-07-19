Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.EditView extends Backbone.View
  template: JST["backbone/templates/crop_controls/edit"]

  events:
    "submit #edit-comment": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (comment) =>
        @model = comment
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
