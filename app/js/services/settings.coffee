settingsFn = ($log, $localstorage, $window) ->

  SETTINGS_DATA_CACHE_KEY = "settings"

  TARGETS =
    live:
      api:    'https://voicerepublic.com'
      upload: 'https://vr-audio-uploads-live.s3.amazonaws.com'
    staging:
      api:    'https://staging:oph5lohb@staging.voicerepublic.com'
      upload: 'https://vr-audio-uploads-staging.s3.amazonaws.com'
    localhost:
      api:    'http://localhost:3000'
      upload: 'https://vr-audio-uploads-dev.s3.amazonaws.com'

  DEFAULTS =
    version: 1
    startUps: 0
    limitDownloadToWifi: true
    target: GLOBALS.DEFAULT_TARGET
    developer: GLOBALS.DEVELOPER_OPTIONS

  data = {}
  data[key] = val for key, val of DEFAULTS

  # load an merge stored settings from local storage
  if $window.localStorage[SETTINGS_DATA_CACHE_KEY]?
    for key, val of $localstorage.getObject(SETTINGS_DATA_CACHE_KEY)
      data[key] = val

  # increment startups and store settings to local storage
  data.startUps += 1
  $localstorage.setObject SETTINGS_DATA_CACHE_KEY, data

  # setup of service complete
  $log.info "setup Settings service #{JSON.stringify(data)}"


  set = (key, value) ->
    data[key] = value
    $localstorage.setObject SETTINGS_DATA_CACHE_KEY, data

  endpoints = ->
    TARGETS[data.target]

  targets = ->
    key for key, val of TARGETS

  reset = ->
    data = DEFAULTS
    $localstorage.setObject SETTINGS_DATA_CACHE_KEY, data
    # FIXME this restarts the app, which might not be nescessary
    $window.location.reload(true)

  # clear the localstorage -- not just settings!
  clear = ->
    $window.localStorage.clear()
    $window.location.reload(true)


  {
    data
    set
    endpoints
    targets
    reset
    clear
  }

angular.module("voicerepublic").service('Settings', settingsFn)
