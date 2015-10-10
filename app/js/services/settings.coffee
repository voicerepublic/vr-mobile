settingsFn = ($log, $window, $localStorage) ->

  _TARGETS =
    live:
      api:    'https://voicerepublic.com'
      upload: 'https://vr-audio-uploads-live.s3.amazonaws.com'
    staging:
      api:    'https://staging:oph5lohb@staging.voicerepublic.com'
      upload: 'https://vr-audio-uploads-staging.s3.amazonaws.com'
    localhost:
      api:    'http://localhost:3000'
      upload: 'https://vr-audio-uploads-dev.s3.amazonaws.com'

  _DEFAULTS =
    version: 1
    startUps: 0
    mobileDownload: false
    target: GLOBALS.DEFAULT_TARGET
    developer: GLOBALS.DEVELOPER_OPTIONS

  attributes = $localStorage.$default(settings: {}).settings
  attributes[key] ||= val for key, val of _DEFAULTS
  attributes.startUps += 1

  # setup of service complete
  $log.info "setup Settings service #{JSON.stringify(attributes)}"


  endpoints = ->
    _TARGETS[attributes.target]

  targets = ->
    key for key, val of _TARGETS

  reset = ->
    attributes = {}
    attributes[key] = val for key, val of _DEFAULTS

  # clear the localstorage -- not just settings!
  clear = ->
    # for some reason this doesn't work properly
    # $localStorage.$reset()
    $window.localStorage.clear()


  {
    attributes
    endpoints
    targets
    reset
    clear
  }

angular.module("voicerepublic").service('Settings', settingsFn)
