Marino.Views.Comments ||= {}

class Marino.Views.Comments.ShowView extends Backbone.View
  template: JST["backbone/templates/comments/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
