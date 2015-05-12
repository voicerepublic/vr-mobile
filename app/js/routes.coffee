angular.module("voicerepublic")

.config ($stateProvider, $urlRouterProvider) ->
  
  # Ionic uses AngularUI Router which uses the concept of states
  # Learn more here: https://github.com/angular-ui/ui-router
  
  $stateProvider

  .state "login",
    url: "/login"
    templateUrl: 'templates/login.html'
    controller: 'loginCtrl'

  .state "tab",
    url: "/tab"
    abstract: true
    templateUrl: "templates/tabs.html"

  .state "tab.record",
    url: "/record"
    views:
      "tab-record":
        templateUrl: 'templates/record.html'
        controller: 'recordCtrl'

  .state "tab.talkList",
    url: "/talkList"
    views:
      "tab-talkList":
        templateUrl: "templates/talkList.html"
        controller: "talkListCtrl"

  .state "tab.upload",
    url: "/upload/:talkToUploadId"
    resolve:
      TalkToUpload: ($stateParams, TalkFactory) ->
        TalkFactory.getTalkById $stateParams.talkToUploadId
    views:
      "tab-talkList":
        templateUrl: "templates/upload.html"
        controller: "uploadCtrl"

  .state "tab.share",
    url: "/share/:talkToShareId"
    resolve:
      TalkToShare: ($stateParams, TalkFactory) ->
        TalkFactory.getTalkById $stateParams.talkToShareId
    views:
      "tab-talkList":
        templateUrl: "templates/share.html"
        controller: "shareCtrl"

  # if none of the above states match, use this as the fallback
  $urlRouterProvider.otherwise "/login"