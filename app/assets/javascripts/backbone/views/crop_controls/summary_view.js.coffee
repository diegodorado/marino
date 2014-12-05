Marino.Views.CropControls ||= {}

class Marino.Views.CropControls.SummaryView extends Backbone.View
  template: JST["backbone/templates/crop_controls/summary"]
  totals_template: JST["backbone/templates/crop_controls/summary_totals"]
  el: "#crop_controls_summary"
  events :
    "change #balance_at" : "date_changed_handler"
    "click #download_excel" : "download_excel_handler"
    
  initialize: () ->
    @collection = new Marino.Collections.CropControlsCollection()
    @collection.reset @options.crop_controls
    @crops = new Marino.Collections.CropsCollection()
    @crops.reset @options.crops
    @balance_at = Date.today().toString('yyyy-MM-dd')

  date_changed_handler: (event)=>

    @balance_at = @$('#balance_at').val()
    @addAll()

  download_excel_handler: (event)=>
    window.location = Routes.summary_crop_controls_path({format:"xlsx", balance_at: @balance_at})

  addAll: () =>
    @$("tbody").empty()

    sorted = @collection.sortBy (cc) ->
      cc.get('fecha')

    filtered = sorted.filter (cc) =>
      cc.get('fecha') <= @balance_at 
    
    grouped = _.groupBy filtered, (cc) ->
      cc.get('crop_id')

    gestion_total = 0
    contabilidad_total = 0
    for crop_id, ccs of grouped

      data=
        crop: @crops.get(crop_id).get('name')
        gestion: {}
        contabilidad: {}

      gestion = _.filter ccs, (cc) -> cc.get('gestion')
      contabilidad = _.filter ccs, (cc) -> cc.get('contabilidad')

      data.gestion.tn = _.reduce gestion, ((memo, cc) -> memo + cc.tn() ) , 0
      data.gestion.unit = 0
      if gestion.length > 0
        data.gestion.unit = _.last(gestion).unit()
      data.gestion.total = data.gestion.tn * data.gestion.unit
      data.contabilidad.tn = _.reduce contabilidad, ((memo, cc) -> memo + cc.tn() ) , 0
      data.contabilidad.unit = 0
      if contabilidad.length > 0
        data.contabilidad.unit = _.last(contabilidad).unit()      
      data.contabilidad.total = data.contabilidad.tn * data.contabilidad.unit

      gestion_total += data.gestion.total
      contabilidad_total += data.contabilidad.total

      view = new Marino.Views.CropControls.SummaryItemView(data)
      @$("tbody").append(view.render().el)

    @$("tfoot").html(@totals_template({ gestion_total: gestion_total, contabilidad_total:contabilidad_total}))


  render: =>
    @$el.html(@template())
    @addAll()
    @$('#balance_at').val @balance_at
    
    @$('.input-group.date').datepicker
      format: "yyyy-mm-dd"
      language: "es"
      orientation: "top auto"
    @
