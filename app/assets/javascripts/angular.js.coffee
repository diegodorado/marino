app = angular.module('app',[
  'templates',
  'ngResource',
  'ngInputModified',
  'ui.bootstrap',
  'ngTable',
])


app.factory 'Store', [
  '$resource',
  ($resource) ->
    $resource '/api/stores/:id.json', {id: '@_id'}, update: method: 'PUT'
]

app.factory 'Crop', [
  '$resource',
  ($resource) ->
    $resource '/api/crops/:id.json', {id: '@_id'}, update: method: 'PUT'
]


app.factory 'CropControl', [
  '$resource',
  ($resource) ->
    $resource '/api/crop_controls/:id.json', {
      id: '@_id'
    }, update:
        method: 'PUT'
    , excel:
        method: 'GET'
        isArray:true
        params:
          excel: 1
]



###*
# AngularJS fixed header scrollable table directive
# @author Jason Watmore <jason@pointblankdevelopment.com.au> (http://jasonwatmore.com)
# @version 1.2.0
###

do ->

  fixedHeader = ($timeout) ->

    link = ($scope, $elem, $attrs, $ctrl) ->
      elem = $elem[0]
      # wait for data to load and then transform the table

      tableDataLoaded = ->
        # first cell in the tbody exists when data is loaded but doesn't have a width
        # until after the table is transformed
        firstCell = elem.querySelector('tbody tr:first-child td:first-child')
        firstCell and !firstCell.style.width

      transformTable = ->
        # reset display styles so column widths are correct when measured below
        angular.element(elem.querySelectorAll('thead, tbody, tfoot')).css 'display', ''
        # wrap in $timeout to give table a chance to finish rendering
        $timeout ->
          # set widths of columns
          angular.forEach elem.querySelectorAll('tr:first-child th'), (thElem, i) ->
            tdElems = elem.querySelector('tbody tr:first-child td:nth-child(' + i + 1 + ')')
            tfElems = elem.querySelector('tfoot tr:first-child td:nth-child(' + i + 1 + ')')
            columnWidth = if tdElems then tdElems.offsetWidth else thElem.offsetWidth
            if tdElems
              tdElems.style.width = columnWidth + 'px'
            if thElem
              thElem.style.width = columnWidth + 'px'
            if tfElems
              tfElems.style.width = columnWidth + 'px'
            return
          # set css styles on thead and tbody
          angular.element(elem.querySelectorAll('thead, tfoot')).css 'display', 'block'
          angular.element(elem.querySelectorAll('tbody')).css
            'display': 'block'
            'height': $attrs.tableHeight or 'inherit'
            'overflow': 'auto'
          # reduce width of last column by width of scrollbar
          tbody = elem.querySelector('tbody')
          scrollBarWidth = tbody.offsetWidth - tbody.clientWidth
          if scrollBarWidth > 0
            # for some reason trimming the width by 2px lines everything up better
            scrollBarWidth -= 2
            lastColumn = elem.querySelector('tbody tr:first-child td:last-child')
            lastColumn.style.width = lastColumn.offsetWidth - scrollBarWidth + 'px'
          return
        return

      $scope.$watch tableDataLoaded, (isTableDataLoaded) ->
        if isTableDataLoaded
          transformTable()
        return
      return

    {
      restrict: 'A'
      link: link
    }

  angular.module('anguFixedHeaderTable', []).directive 'fixedHeader', fixedHeader
  fixedHeader.$inject = [ '$timeout' ]
  return
