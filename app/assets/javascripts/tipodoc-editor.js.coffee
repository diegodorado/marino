$ = jQuery

values = [
  'EX INIC'
  'CONSUMO'
  'COSECHA'
  'MERMAS'
  'VENTAS'
]

options = ("<option value='#{v}'>#{v}</option>" for v in values)

TipodocEditor = (args) ->
  $select = undefined
  defaultValue = undefined
  scope = this
  @init = ->
    $select = $("<select class='select-slick-editor'>#{options.join('')}</select>")
    $select.appendTo(args.container)
    $select.focus().select()

  @destroy = ->
    $select.remove()

  @focus = ->
    $select.focus()

  @getValue = ->
    $select.val()

  @setValue = (val) ->
    $select.val val

  @loadValue = (item) ->
    defaultValue = item[args.column.field] or ""
    @setValue defaultValue
    $select.select()
    

  @serializeValue = ->
    $select.val()

  @applyValue = (item, state) ->
    item[args.column.field] = state

  @isValueChanged = ->
    (not ($select.val() is "" and not defaultValue?)) and ($select.val() isnt defaultValue)

  @validate = ->
    if args.column.validator
      validationResults = args.column.validator($select.val())
      return validationResults  unless validationResults.valid
    valid: true
    msg: null

  @init()
  return @



$.extend(true, window, {
  "Slick": {
    "Editors": {
      "Tipodoc": TipodocEditor
    }
  }
})
