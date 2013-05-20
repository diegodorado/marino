Marino.Views.Comments ||= {}

class Marino.Views.Comments.IndexView extends Backbone.View
  template: JST["backbone/templates/comments/index"]
  el: "#chat_viewport"

  events:
    'submit .send': 'send_message'
    'click .chat_title': 'toggle'

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
    @$('#chat').addClass 'in'
    @cache.open = true

  close: ->
    @$('#chat').removeClass 'in'
    @cache.open = false

  toggle: (event) ->
    if @$('#chat').hasClass('in') then @close() else @open()

  send_message: (event) ->
    event.preventDefault()
    msg = @$('.send input').val()
    return unless msg
    @options.comments.add
      text: msg
    @$('.send input').val('').focus()


  addAll: () =>
    @options.comments.each(@addOne)

  addOne: (comment) =>
    view = new Marino.Views.Comments.CommentView({model : comment})
    @$('.messages').append view.render().el
    @$('.messages').get(0).scrollTop = 10000000

  render: =>
    @$el.html(@template(comments: @options.comments.toJSON() ))
    @addAll()
    if @cache.open
      @open() 
    
    @
