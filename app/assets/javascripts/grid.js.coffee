accounting.settings =
	currency:
		symbol : "$"   # default currency symbol is '$'
		format: "%s %v" # controls output: %s = symbol, %v = value/number (can be object: see below)
		decimal : "." # decimal point separator
		thousand: " " # thousands separator
		precision : 2  # decimal places
	number:
		precision : 3 # default precision on numbers is 0
		thousand: " " 
		decimal : "."

MoneyFormatter= (row, cell, value, columnDef, dataContext) ->
  accounting.formatMoney(value)

NumberFormatter= (row, cell, value, columnDef, dataContext) ->
  accounting.formatNumber(value)