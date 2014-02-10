Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.SummaryItemView extends Backbone.View
  template: JST["backbone/templates/crop_controls/summary_item"]

  tagName: "tr"

  initialize: (data) ->
    @data = data

  render: ->
    @$el.html(@template(@data ))
    @