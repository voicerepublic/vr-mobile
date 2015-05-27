###
@ngdoc controller
@name uploadCtrl

@function

@description
  This Controller is responsible for the uploading view.
  It uses the following services & factories:
  - TalkFactory
  - Uploader

  **Note:** 
  Using the following cordova plugins:
  - cordova.toast
###
angular.module("voicerepublic")

.controller "uploadCtrl", ($scope, $rootScope, $http, $cordovaFileTransfer, $cordovaProgress, $window, $log, $state, $timeout, $ionicHistory, $cordovaToast, $localstorage, TalkToUpload, TalkFactory) ->
  #the form
  $scope.form = {}
  #needed to keep track of uploading
  #if user swipes away
  $scope.uploaded = no

  #get the "resolved" talk
  $scope.talk = TalkToUpload

  #swipe actions
  #
  #swiped right
  $scope.onSwipedRight = () ->
    #redirect, probably more 
    #to do here
    $scope.back() if $scope.uploaded

  #button actions
  #
  $scope.back = () ->
    $ionicHistory.goBack -1

  $scope.startUpload = () ->
    $window.uploadForm = $scope.form
    #just cosmetics
    $scope.form.upload.$setSubmitted()
    #manual validation
    $scope.form.upload.title.$validate()
    $scope.form.upload.teaser.$validate()
    $scope.form.upload.tags.$validate()
    $scope.form.upload.description.$validate()
    #dont execute if form invalid
    if $scope.form.upload.$invalid
      $cordovaToast.showShortBottom "Please provide more information"
      return 

    #URLS
    talk_upload_url = "https://vr-audio-uploads-live.s3.amazonaws.com"
    meta_data_url = "https://voicerepublic.com/talks/upload"

    #upload options
    options = {}
    options.fileKey = "file"
    options.fileName = TalkToUpload.filename
    options.mimeType = "audio/wav" if $window.ionic.Platform.isIOS()
    options.mimeType = "audio/amr" if $window.ionic.Platform.isAndroid()
    optParams = {}
    optParams.key = $window.sha1 "#{TalkToUpload.filename}:#{$localstorage.get 'user_email'}:#{$localstorage.get 'csrfToken'}"
    options.params = optParams

    #every plugin has its own URL WTF??!11
    source = ""
    if $window.ionic.Platform.isIOS()
      source = "cdvfile://localhost/persistent/talks/#{TalkToUpload.filename}"
    if $window.ionic.Platform.isAndroid()
      source = "cdvfile://localhost/persistent/#{TalkToUpload.nativeUrl.replace 'file:///storage/emulated/0', ''}"

    #state params
    params = 
      talkToShareId: TalkToUpload.id

    #native upload
    #
    #progress flag needed
    firstProgress = yes

    uploadingPromise = $cordovaFileTransfer.upload talk_upload_url, source, options
    uploadingPromise.then((success) ->
      #get the god damn token
      $http.get("https://voicerepublic.com/uploads/new")
      .success (data) ->
        #get/extract the csrf token
        $log.debug data
        el = angular.element data
        authToken = el.find("input[name=authenticity_token]").val()
        #save the token for the interceptor and further usage
        $localstorage.set "csrfToken", authToken
        #options for the POST request
        optionsPost =
          url: "https://voicerepublic.com/uploads"
          method: "POST"
          headers:
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
          params:
            "commit": "Save"
            "authenticity_token": authToken
            "talk[description]": "<p>#{$scope.talk.description}</p>"
            "talk[language]": "en"
            "talk[starts_at_date]": "2015-05-05"#$scope.talk.recordDate
            "talk[starts_at_time]": "00:10"#$scope.talk.recordTime
            "talk[tag_list]": $scope.talk.tags
            "talk[teaser]": $scope.talk.teaser
            "talk[title]": $scope.talk.title
            "talk[user_override_uuid]": optParams.key
            "talk[new_venue_title]": "Mobile Talks"

        #send metadata to VR Backend
        $http(optionsPost)
        .success (data, status, headers, config) ->
          $cordovaProgress.hide()
          $cordovaProgress.showSuccess true, "Talk uploaded!"
          $timeout ->
            $cordovaProgress.hide()
          , 1337
          #get/extract the csrf token
          $log.debug data
          el = angular.element data
          authToken = el.find("input[name=authenticity_token]").val()
          #save the token for the interceptor and further usage
          $localstorage.set "csrfToken", authToken

          TalkFactory.setTalkUploaded $scope.talk, "https://voicerepublic.com/talks/#{$scope.talk.title}"
          $state.go "tab.share", params
        .error (data, status, headers, config) ->
          $cordovaProgress.hide()
          $cordovaProgress.showText false, "Talk upload failed! Please try again", "center"
          $timeout ->
            $cordovaProgress.hide()
          , 2000
          #logging
          $log.debug status
          $log.debug headers
          $log.debug config
      .error (data, status, headers, config) ->
        $cordovaProgress.hide()
        $cordovaProgress.showText false, "Talk upload failed! Please try again", "center"
        $timeout ->
          $cordovaProgress.hide()
        , 2000
        #logging
        $log.debug status
        $log.debug headers
        $log.debug config
    (err) ->
      $cordovaProgress.hide()
      $cordovaProgress.showText false, "Talk upload failed! Please try again", "center"
      $timeout ->
        $cordovaProgress.hide()
      , 2000
      $log.debug err
    (progress) ->
      $cordovaProgress.hide() unless firstProgress
      uploadProgress = (progress.loaded / progress.total) * 100
      uploadProgress = $window.Math.round((uploadProgress + 0.00001) * 100) / 100
      $cordovaProgress.showSimpleWithLabel false, "#{uploadProgress}%"
      #not the first anymore
      firstProgress = no
    )

    
