
class Application
  constructor: ->
    @utils =
      num_to_s: (num) ->
        num = num + ''
        num = '0' + num if num.length is 1
        num
    @options = {}

  load: (options) ->
    for key, val of options
      @options[key] = val

  start: ->
    $ => @onReadyLoad()

  onReadyLoad: ->
    #set users
    @user_id = @options.user_id

    if @options.crop_control
      window.router = new Marino.Routers.CropControlsRouter(@options)
      Backbone.history.start()

    # backup upload
    if @options.backups
      $('.fileinput .btn-primary').on 'click', (ev) ->
        ev.preventDefault()
        $(this).closest('form').submit()

window.app = new Application
