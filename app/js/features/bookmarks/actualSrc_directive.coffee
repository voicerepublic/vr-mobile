###
@ngdoc directive
@name checkImage

@object

@description
  This directive shows default pictures when there is no connectivity or url is broken.

###
angular.module("voicerepublic")

.directive 'actualSrc', ->
  { 
    link: (scope, element, attrs) ->
      attrs.$observe 'actualSrc', (newVal, oldVal) ->
        if newVal != undefined
          img = new Image
          img.src = attrs.actualSrc
          angular.element(img).bind 'load', ->
            element.attr 'src', attrs.actualSrc
 }