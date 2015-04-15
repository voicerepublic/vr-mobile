angular.module("voicerepublic")

.factory 'FormFactory', ($q) ->

  ###
  Basic form class that you can extend in your actual forms.

  Object attributes:
  - loading[Boolean] - is the request waiting for response?
  - message[String] - after response, success message
  - errors[String[]] - after response, error messages

  Options:
    - submitPromise[function] (REQUIRED) - creates a form request promise
    - onSuccess[function] - will be called on succeded promise
    - onFailure[function] - will be called on failed promise
  ###
  class FormFactory
    constructor: (@options = {}) ->
      @loading = false

    submit: ->
      @_handleRequestPromise @_createSubmitPromise() unless @loading

    _onSuccess: (response) ->
        @message = response.message || response.success
        response

    _onFailure: (response) ->
      @errors = response.data?.data?.errors || response.data?.errors || [response.data?.error || response.error || response.data?.message || response.message || "Something has failed. Try again."]
      $q.reject(response)

    _createSubmitPromise: ->
      @options.submitPromise()

    _handleRequestPromise: (@$promise, onSuccess, onFailure) ->
      @loading = true
      @submitted = false
      @message = null
      @errors = []

      @$promise
        .then (response) =>
          @errors = []
          @submitted = true
          response

        .then(_.bind @_onSuccess, @)
        .then(onSuccess || @options.onSuccess)

        .catch(_.bind @_onFailure, @)
        .catch(onFailure || @options.onFailure)

        .finally =>
          @loading = false

      @$promise
