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

    if @options.backups
      return

  
    if @options.grid
      
      for c in @options.grid.columns
        c.editor = eval(c.editor) if c.editor
        c.formatter = eval(c.formatter) if c.formatter

      @grid.initGrid '#grid', @options.grid.columns, @options.grid.options
      @grid.model.loadData()
      @grid.initLoader()
      @grid.initWriter()
      

    if @options.crop_prices
      @grid = new @CropGrid '#crop_prices_grid', @options.crop_prices
      


window.app = new Application  
