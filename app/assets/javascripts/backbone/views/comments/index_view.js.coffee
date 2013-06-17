Marino.Views.Comments ||= {}

class Marino.Views.Comments.IndexView extends Backbone.View
  template: JST["backbone/templates/comments/index"]
  el: "#comments"

  events:
    'submit .send': 'send_message'

  cache:
    open: false

  initialize: () ->
    @options.comments.bind('reset', @addAll)
    @options.comments.bind('add', @addOne)
    #gets cache and attachs handler to save it on page unload
    @cache = store.get('chat-cache') or @cache
    $(window).unload () =>
      store.set('chat-cache', @cache)

  open: ->
    @cache.open = true

  send_message: (event) ->
    event.preventDefault()
    msg = @$('.send input').val()
    return unless msg
    @options.comments.create
      text: msg
      ,
        silent:true
        success: ((model)=> @addOne(model))
    
    @$('.send input').val('').focus()

  addAll: () =>
    @options.comments.each(@addOne)

  addOne: (comment) =>
    view = new Marino.Views.Comments.CommentView({model : comment})
    @$('.messages table').append view.render().el
    @$('.messages').get(0).scrollTop = 10000000

  render: =>
    @$el.html(@template(comments: @options.comments.toJSON() ))
    @addAll()
    @
