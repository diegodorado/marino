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


    if @options.crop_prices
      @grid = new @CropGrid '#crop_prices_grid', @options.crop_prices


    if @options.crop_control
      @crop_control_grid = new @CropControlGrid
      @crop_control_grid.dataView.setItems @options.crop_controls
      @crop_control_grid.updateFilter()
  
      #window.router = new Marino.Routers.CommentsRouter({comments: @options.company_comments})
      #Backbone.history.start()
      comments = new Marino.Collections.CommentsCollection()
      comments.reset @options.company_comments
      view = new Marino.Views.Comments.IndexView(comments: comments)
      view.render()

  

window.app = new Application  
