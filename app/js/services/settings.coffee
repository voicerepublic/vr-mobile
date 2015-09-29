settingsFn = ($log, $localstorage, $window) ->

  SETTINGS_DATA_CACHE_KEY = "settings"

  DEFAULTS =
    limitDownloadToWifi: true

  data = DEFAULTS

  if $window.localStorage[SETTINGS_DATA_CACHE_KEY]?
    data = $localstorage.getObject SETTINGS_DATA_CACHE_KEY
  else
    $localstorage.setObject SETTINGS_DATA_CACHE_KEY, data

  $log.info "setup Settings service #{JSON.stringify(data)}"

  set = (key, value) ->
    data[key] = value
    $localstorage.setObject SETTINGS_DATA_CACHE_KEY, data

  {
    set
    data
  }

angular.module("voicerepublic").service('Settings', settingsFn)
