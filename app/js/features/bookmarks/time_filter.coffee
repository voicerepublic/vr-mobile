###
@ngdoc filters
@name Filters

@function

@description
  Filter helpers for time duration display

###
angular.module("voicerepublic")

.filter 'time', ->
  (input) ->
    input = input or 0
    t = parseInt(input, 10)

    if t <= 0
      return '00:00:00'

    h = t / 3600
    m = (t % 3600) / 60
    s = t % 60

    addLeadingZero = (n) ->
      if n < 10 then '0' + n else n

    addLeadingZero(Math.floor(h)) + ':' + addLeadingZero(Math.floor(m)) + ':' + addLeadingZero(s)
