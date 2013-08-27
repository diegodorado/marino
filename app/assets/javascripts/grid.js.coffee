accounting.settings =
	currency:
		symbol : "$"   # default currency symbol is '$'
		format: "%s%v" # controls output: %s = symbol, %v = value/number (can be object: see below)
		decimal : " " # decimal point separator
		thousand: "," # thousands separator
		precision : 2  # decimal places
	number:
		precision : 3 # default precision on numbers is 0
		thousand: " " 
		decimal : "."


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
