Marino.Views.Comments ||= {}

class Marino.Views.Comments.IndexView extends Backbone.View
  template: JST["backbone/templates/comments/index"]

  initialize: () ->
    @options.comments.bind('reset', @addAll)

  addAll: () =>
    @options.comments.each(@addOne)

  addOne: (comment) =>
    view = new Marino.Views.Comments.CommentView({model : comment})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(comments: @options.comments.toJSON() ))
    @addAll()

    return this
