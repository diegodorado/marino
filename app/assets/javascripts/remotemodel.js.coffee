class RemoteModel
  constructor: (@base_url) ->
    @onDataLoading = new Slick.Event()
    @onDataLoaded = new Slick.Event()
    @onDataLoadedSuccess = new Slick.Event()
    @onDataLoadedError = new Slick.Event()

    @onDataWriting = new Slick.Event()
    @onDataWritten = new Slick.Event()
    @onDataWrittenSuccess = new Slick.Event()
    @onDataWrittenError = new Slick.Event()

    @onCreating = new Slick.Event()
    @onCreated = new Slick.Event()
    @onCreatedSuccess = new Slick.Event()
    @onCreatedError = new Slick.Event()

    @onDeleting = new Slick.Event()
    @onDeleted = new Slick.Event()
    @onDeletedSuccess = new Slick.Event()
    @onDeletedError = new Slick.Event()


    @request = null

  loadData: ->
    if @request
      @request.abort()

    @onDataLoading.notify()

    @request = $.ajax
      url: "#{@base_url}.json"
      dataType: 'json'
      cache: false
      complete: =>
        @onDataLoaded.notify()
      success: (response) =>
        @request = null
        @onDataLoadedSuccess.notify({data: response})
      error: =>
        @onDataLoadedError.notify()

  writeData: (args) ->
    @onDataWriting.notify()
    $.ajax
      url: "#{@base_url}/#{args.item.id}.json"
      type: 'PUT'
      data: args.item
      dataType: 'json'
      complete: =>
        @onDataWritten.notify()
      success: (response) =>
        @onDataWrittenSuccess.notify({
          row: args.row
          item: response
        })
      error: =>
        @onDataWrittenError.notify()


  addItem: (item) ->
    @onCreating.notify()
    $.ajax
      url: "#{@base_url}.json"
      type: 'POST'
      data: item
      dataType: 'json'
      complete: =>
        @onCreated.notify()
      success: (response) =>
        @onCreatedSuccess.notify({
          item: response
        })
      error: =>
        @onCreatedError.notify()

  deleteItem: (item) ->
    @onDeleting.notify()
    $.ajax
      url: "#{@base_url}/#{item.id}.json"
      type: 'DELETE'
      dataType: 'json'
      complete: =>
        @onDeletedSuccess.notify
          item: item


$.extend(true, window, {
  "Slick": {
    "Data": {
      "RemoteModel": RemoteModel
    }
  }
})
