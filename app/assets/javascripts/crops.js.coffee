class CropGrid

  constructor: (selector, crop_prices) ->

    for c in crop_prices.columns
      c.editor = eval(c.editor) if c.editor
      c.formatter = eval(c.formatter) if c.formatter
    
    @dataView = new Slick.Data.DataView()
    @dataView.setItems(crop_prices.data)
    @grid = new Slick.Grid(selector, @dataView, crop_prices.columns, crop_prices.options)

    @grid.render()


    @grid.onCellChange.subscribe (e, args) =>

      id = args.item.id
      month = args.grid.getColumns()[args.cell]['field']
      price = args.item[month]
      $.ajax
        url: "/crops/#{id}.json"
        type: 'PUT'
        data: {month: month, price: price}
        dataType: 'json'
        success: (response) =>
          console.log response



app.CropGrid = CropGrid      


