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

  # for some stupid reason boolean options should always be false by
  # default
  _DEFAULTS =
    version: 1
    startUps: 0
    mobileDownload: false
    suppressDevGreeting: false
    target: GLOBALS.DEFAULT_TARGET
    developer: false

  # load settings from localstorage
  attributes = $localStorage.$default(settings: {}).settings

  $log.info "settings A: #{JSON.stringify(attributes)}"

  # merge missing defaults
  for key, val of _DEFAULTS
    $log.info "settings: check #{key} (#{val})"
    if !attributes[key]?
      $log.info "settings: set #{key} to #{val}"
      attributes[key] = val

  $log.info "settings B: #{JSON.stringify(attributes)}"

  attributes.startUps += 1

  $log.info "settings C: #{JSON.stringify(attributes)}"

  # setup of service complete
  $log.info "setup Settings service #{JSON.stringify(attributes)}"


  endpoints = ->
    _TARGETS[attributes.target]

  targets = ->
    key for key, val of _TARGETS

  reset = ->
    $localStorage.settings = {}
    $localStorage.settings[key] = val for key, val of _DEFAULTS

  # clear the localstorage -- not just settings!
  clear = ->
    # for some reason this doesn't work properly
    # $localStorage.$reset()
    $window.localStorage.clear()
    # TODO for a full factory reset we also need to delete files


  {
    attributes
    endpoints
    targets
    reset
    clear
  }

angular.module("voicerepublic").service('Settings', settingsFn)
