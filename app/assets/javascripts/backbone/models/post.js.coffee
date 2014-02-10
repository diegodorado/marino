class Marino.Models.Post extends Backbone.Model
  paramRoot: 'post'

  defaults:
    title: null
    content: null

class Marino.Collections.PostsCollection extends Backbone.Collection
  model: Marino.Models.Post
  url: '/posts'
