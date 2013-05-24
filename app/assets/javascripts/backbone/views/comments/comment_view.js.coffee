Marino.Views.Comments ||= {}

class Marino.Views.Comments.CommentView extends Backbone.View
  template: JST["backbone/templates/comments/comment"]
  className: 'user_message message'

  events:
    "click .destroy" : "destroy"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    @$(".avatar").tooltip { placement: 'left'}
    @$('time').timeago()    
    @
    
