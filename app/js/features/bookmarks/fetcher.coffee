###
@ngdoc factory
@name Fetcher

@object

@description
  The Fetcher

@models
  bookmarked_talk =
    key: value

@examples
  For private usage
  -----------------

  For public usage
  ----------------
###
angular.module("voicerepublic")

.factory 'Fetcher', ($http, ObserverFactory, Settings) ->
  new class Fetcher extends ObserverFactory
    constructor: () ->
      @baseUrl = Settings.endpoints().api
      @offset = 0
      @limit = 10
      @canLoadMore = yes

    _shiftOffset: ->
      @offset += @limit

    _resetOffset: ->
      @offset = 0

    _fetchNextBundle: ->
      self = @
      data =
        limit: self.limit
        offset: self.offset
        order: 'processed_at'
        reverse: yes

      promise = $http.get "#{@baseUrl}/api/bookmarks", {params: data}
      promise.then ((response) ->
        loadedTalks = response.data
        self.fireEvent 'bundleLoaded', loadedTalks
        self.canLoadMore = (loadedTalks.length == self.limit)
        self._shiftOffset() if self.canLoadMore
      ), ((error) ->
        self.canLoadMore = no
        self.fireEvent 'error', error
      )

    loadNextBundle: ->
      @_fetchNextBundle()

    refresh: ->
      #reset and load as usual
      @canLoadMore = yes
      @_resetOffset()
      @_fetchNextBundle()
