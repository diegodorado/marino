accounting.settings =
	currency:
		symbol : "$"   # default currency symbol is '$'
		format: "%s%v" # controls output: %s = symbol, %v = value/number (can be object: see below)
		decimal : "." # decimal point separator
		thousand: "," # thousands separator
		precision : 2  # decimal places
	number:
		precision : 3 # default precision on numbers is 0
		thousand: " " 
		decimal : ","


DateFormatter= (row, cell, value, columnDef, dataContext) ->
  p = value.match(/(\d+)/g)
  "#{p[2]}/#{p[1]}/#{p[0]}"


MoneyFormatter= (row, cell, value, columnDef, dataContext) ->
  accounting.formatMoney(value)

NumberFormatter= (row, cell, value, columnDef, dataContext) ->
  accounting.formatNumber(value)


to_date = (s)->
  return '' unless s
  p = s.match(/(\d+)/g)
  "#{p[2]}/#{p[1]}/#{p[0]}"

comparer = (a, b) ->
  x = to_date(a["fecha"])
  y = to_date(b["fecha"])
  (if x is y then 0 else ((if x > y then 1 else -1)))


class Grid

  constructor: ->

    @dataView = new Slick.Data.DataView
    @grid = new Slick.Grid("#crop_control_grid", @dataView, columns, options)
    @grid.setSelectionModel new Slick.RowSelectionModel()
    @model = new Slick.Data.RemoteModel('/crop_controls')    


    $('#store_select').change (e) =>
      Slick.GlobalEditorLock.cancelCurrentEdit()
      @updateFilter()
      $("#add_cc").toggleClass 'disabled', $('#store_select').val() is ''
      
    $('#crop_select').change (e) =>
      Slick.GlobalEditorLock.cancelCurrentEdit()
      @updateFilter()

    $("#add_cc").click (e) =>
      return if $("#add_cc").hasClass 'disabled'
      prev = @dataView.getItem @dataView.getLength()-1
      item =
        store_id: $('#store_select').val()
        crop_id: $('#crop_select').val()
        fecha: prev.fecha if prev
        tipo_doc: prev.tipo_doc if prev
        entrada: 0
        salida: 0
        precio_unitario: prev.precio_unitario if prev
      @model.createItem(item)

    @model.onCreated.subscribe (e, args) =>
      @dataView.addItem args.item
      @dataView.refresh()
      @calculateItems()
      @grid.invalidateAllRows()
      @grid.render()


    @grid.onSelectedRowsChanged.subscribe () =>
      $("#delete_cc").toggleClass 'disabled', @grid.getSelectedRows().length is 0

    $("#delete_cc").click (e) =>
      for row in @grid.getSelectedRows()
        item = @grid.getDataItem row
        @model.deleteItem(item)

    @model.onDeleted.subscribe (e, args) =>
      @dataView.deleteItem args.item.id
      @dataView.refresh()
      @calculateItems()
      @grid.invalidateAllRows()
      @grid.render()


    @grid.onCellChange.subscribe (e, args) =>
      console.log e, args
      
      @model.updateItem(args.item)

    @model.onUpdated.subscribe (e, args) =>
      console.log e, args
      @dataView.updateItem args.item.id, args.item
      @updateFilter()

    @grid.onKeyDown.subscribe (e) =>
      return false  if e.which isnt 65 or not e.ctrlKey
      rows = []
      i = 0
      console.log @dataView.getLength()
      while i < @dataView.getLength()
        rows.push i
        i++
      @grid.setSelectedRows rows
      e.preventDefault()
    
    @dataView.setFilter (item, args) ->
      #console.log item, args
      return false  if item["crop_id"] isnt args.crop_id
      return false  if item["store_id"] isnt args.store_id and args.store_id isnt ''
      true
    
    @updateFilter()
    
    # if you don't want the items that are not visible (due to being filtered out
    # or being on a different page) to stay selected, pass 'false' to the second arg
    @dataView.syncGridSelection @grid, false


  updateFilter: ->
    @dataView.setFilterArgs
      store_id: $('#store_select').val()
      crop_id: $('#crop_select').val()
    @dataView.sort comparer, 1
    @dataView.refresh()
    
    @calculateItems()
    @grid.invalidateAllRows()
    @grid.render()

  calculateItems: ->
    saldo = 0
    saldo_p = 0
    l = @dataView.getLength()
    for i in [0..l-1] when l > 0
      item =@dataView.getItem(i)
      item.entrada or=0
      item.salida or=0
      item.precio_unitario or=0
      saldo += item.entrada-item.salida
      item.saldo = saldo
      item.debe = item.entrada*item.precio_unitario
      item.haber = item.salida*item.precio_unitario
      saldo_p += item.debe-item.haber
      item.saldo_p = saldo_p
      @dataView.updateItem item.id, item





app.CropControlGrid = Grid
