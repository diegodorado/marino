class Marino.Routers.CommentsRouter extends Backbone.Router
  initialize: (options) ->
    @comments = new Marino.Collections.CommentsCollection()
    @comments.reset options.comments

  routes:
    "new"      : "newComment"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newComment: ->
    @view = new Marino.Views.Comments.NewView(collection: @comments)
    $("#comments").html(@view.render().el)

  index: ->
    @view = new Marino.Views.Comments.IndexView(comments: @comments)
    $("#comments").html(@view.render().el)

  show: (id) ->
    comment = @comments.get(id)

    @view = new Marino.Views.Comments.ShowView(model: comment)
    $("#comments").html(@view.render().el)

  edit: (id) ->
    comment = @comments.get(id)

    @view = new Marino.Views.Comments.EditView(model: comment)
    $("#comments").html(@view.render().el)
