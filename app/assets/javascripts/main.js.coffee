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


    if @options.crop_admin
      window.router = new Marino.Routers.CropsRouter(@options)
      Backbone.history.start()


    if @options.crop_control

      comments = new Marino.Collections.CommentsCollection()
      comments.reset @options.company_comments
      view = new Marino.Views.Comments.IndexView(comments: comments)
      #view.render()

      window.router = new Marino.Routers.CropControlsRouter(@options)
      Backbone.history.start()
      
      #view = new Marino.Views.CropControls.IndexView
      #  crop_controls: crop_controls
      #  company: @options.company
      #  stores: @options.stores
      #  crops: @options.crops
      

    if @options.crop_controls_summary
      
      view = new Marino.Views.CropControls.SummaryView
        company: @options.company
        crops: @options.crops
        crop_controls: @options.crop_controls

      view.render()

window.app = new Application  
