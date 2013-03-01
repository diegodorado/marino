class Grid
  initGrid: (@selector, @columns, @options) ->
    @dataView = new Slick.Data.DataView()
    @grid = new Slick.Grid(@selector, @dataView, @columns, @options)
    @model = new Slick.Data.RemoteModel('/messages')
    @grid.setSortColumn "tipo_doc", true

  initLoader: ->

    @model.onDataLoadedSuccess.subscribe (e, args) =>
      @dataView.beginUpdate()
      @dataView.setItems(args.data)
      @dataView.endUpdate()
      @dataView.fastSort()
      @calculateItems()
      @grid.invalidateAllRows()
      @grid.render()


  calculateItems: ->
    saldo = 0
    saldo_p = 0
    items = for item in @dataView.getItems()
      item.entrada or=0
      item.salida or=0
      item.precio_unitario or=0
      saldo += item.entrada-item.salida
      item.saldo = saldo
      item.debe = item.entrada*item.precio_unitario
      item.haber = item.salida*item.precio_unitario
      saldo_p += item.debe-item.haber
      item.saldo_p = saldo_p
      item
    @dataView.setItems(items)

  initWriter: ->

    @model.onDataWrittenSuccess.subscribe (e, args) =>
      false
      
    @grid.onCellChange.subscribe (e, args) =>
      console.log args
      @model.writeData(args)
      @dataView.updateItem(args.item.id, args.item)
      #@grid.updateRow(args.row)
      
      @calculateItems()
      @grid.invalidateAllRows()
      @grid.render()

    @grid.onAddNewRow.subscribe (e, args) =>
      @model.addItem(args.item)


    @model.onCreatedSuccess.subscribe (e, args) =>
      @dataView.addItem args.item
      @grid.invalidate()

    @grid.onContextMenu.subscribe (e, args) =>
      e.preventDefault()
      cell = @grid.getCellFromEvent(e)
      $("#contextMenu")
          .data("row", cell.row)
          .css("top", e.pageY)
          .css("left", e.pageX)
          .show()

      $("body").one "click", ->
        $("#contextMenu").hide()


    $("#contextMenu").on 'click', 'li', (e) =>
      item = @grid.getDataItem $("#contextMenu").data("row")
      @model.deleteItem(item)

    @model.onDeleted.subscribe (e, args) =>
      console.log 'asdfasdf',args

    @model.onDeletedSuccess.subscribe (e, args) =>
      @dataView.deleteItem args.item.id
      @grid.invalidate()


app.grid = new Grid      
