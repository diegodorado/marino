class Marino.Models.Comment extends Backbone.Model
  idAttribute: '_id'

  defaults:
    text: null

class Marino.Collections.CommentsCollection extends Backbone.Collection
  model: Marino.Models.Comment
  url: '/comments'
