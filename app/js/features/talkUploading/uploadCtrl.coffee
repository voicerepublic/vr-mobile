###
@ngdoc controller
@name uploadCtrl

@function

@description
  This Controller is responsible for the uploading view.
  It uses the following services & factories:
  - TalkFactory
  - Auth

  **Note:** 
  Using the following cordova plugins:
  - cordova.toast
  - cordovaFileTransfer
###
angular.module("voicerepublic")

.controller "uploadCtrl", ($scope, $rootScope, $http, $cordovaFileTransfer, $ionicLoading, $window, $log, $state, $timeout, $ionicHistory, $cordovaToast, $localstorage, TalkToUpload, TalkFactory, Auth) ->
  #the form
  $scope.form = {}

  #needed to keep track of uploading
  #if user swipes away
  $scope.uploaded = no

  #get the "resolved" talk
  $scope.talk = TalkToUpload

  #get the series & init selections
  $scope.series = Auth.getSeries()
  $scope.talk.serie = $scope.series[0].id
  $scope.talk.language = "en"

  #uploadProgress
  $scope.uploadProgress = "0.00%"
  #ionicloading uploading template
  if $window.ionic.Platform.isAndroid()
    condTemplate = '<ion-spinner icon="android"></ion-spinner> <br/> <strong>{{uploadProgress}}</strong> <br/> uploaded...'
  if $window.ionic.Platform.isIOS()
    condTemplate = '<ion-spinner icon="ios"></ion-spinner> <br/> <strong>{{uploadProgress}}</strong> <br/> uploaded...'
  ionicLoadingOpts = 
    template: condTemplate
    scope: $scope
    hideOnStateChange: yes

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

    # URL's
    #talk_upload_url = "https://vr-audio-uploads-live.s3.amazonaws.com"
    #meta_data_url = "https://voicerepublic.com/api/uploads"
    talk_upload_url = "https://vr-audio-uploads-staging.s3.amazonaws.com"
    meta_data_url = "https://staging.voicerepublic.com/api/uploads"

    #upload options
    options = {}
    options.fileKey = "file"
    options.fileName = TalkToUpload.filename
    options.mimeType = "audio/wav" if $window.ionic.Platform.isIOS()
    options.mimeType = "audio/amr" if $window.ionic.Platform.isAndroid()
    optParams = {}
    optParams.key = $window.sha1 "#{TalkToUpload.filename}:#{$localstorage.get 'user_email'}:#{Math.random()*1337%1111}"
    options.params = optParams

    #every plugin has its own URL to files WTF??!11
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
    #show the talk uploading modal
    $ionicLoading.show ionicLoadingOpts
    #start the upload process
    uploadingPromise = $cordovaFileTransfer.upload talk_upload_url, source, options
    uploadingPromise.then((success) ->
      $ionicLoading.hide()
      #ionicloading metadata uploading template
      if $window.ionic.Platform.isAndroid()
        condTemplateMeta = '<ion-spinner icon="android"></ion-spinner> <br/> uploading metadata...'
      if $window.ionic.Platform.isIOS()
        condTemplateMeta = '<ion-spinner icon="ios"></ion-spinner> <br/> uploading metadata...'
      ionicLoadingOptsMeta = 
        template: condTemplateMeta
        hideOnStateChange: yes
      #show metadata upload modal
      $ionicLoading.show ionicLoadingOptsMeta
      #metadata payload
      payload =
        "description": $scope.talk.description
        "language": $scope.talk.language
        "starts_at_date": $scope.talk.starts_at_date
        "starts_at_time": $scope.talk.starts_at_time
        "tag_list": $scope.talk.tags
        "teaser": $scope.talk.teaser
        "title": $scope.talk.title
        "user_override_uuid": optParams.key
        "venue_id": $scope.talk.serie
        "duration": $scope.talk.duration.substring 3, 5
      #send metadata to VR Backend
      $http.post(meta_data_url, {talk: payload})
      .success (data, status) ->
        $ionicLoading.hide()
        $cordovaToast.showShortBottom "Talk upload successfull!"
        #shareUrl = "https://voicerepublic.com/talks/"
        shareUrl = "https://staging.voicerepublic.com/talks/"
        #save slug etc.
        TalkFactory.setTalkUploaded $scope.talk, shareUrl + data.slug
        $state.go "tab.share", params
      .error (data, status) ->
        $ionicLoading.hide()
        $cordovaToast.showShortBottom "Could not upload the talk metadata, please try again"
    (err) ->
      $cordovaToast.showShortBottom "Could not upload the talk, please try again"
      $log.debug err
    (progress) ->
      upProgress = (progress.loaded / progress.total) * 100
      upProgress = $window.Math.round((upProgress + 0.00001) * 100) / 100
      $scope.uploadProgress = "#{upProgress}%"
    )