###
@ngdoc controller
@name uploadCtrl

@function

@description
  This Controller is responsible for the uploading view.
  It uses the following services & factories:
  - TalkFactory
  - User

  **Note:**
  Using the following cordova plugins:
  - cordova.toast
  - cordovaFileTransfer
###
uploadCtrlFn = ( $scope,
                 $rootScope,
                 $http,
                 $window,
                 $log,
                 $state,
                 $timeout,
                 $ionicLoading,
                 $ionicHistory,
                 $cordovaToast,
                 $cordovaFileTransfer,
                 $localstorage,
                 TalkToUpload,
                 TalkFactory,
                 User,
                 Settings ) ->

  #the form
  $scope.form = {}

  #needed to keep track of uploading
  #if user swipes away
  $scope.uploaded = no

  #get the "resolved" talk
  $scope.talk = TalkToUpload

  $scope.listOfSeries = User.attributes.list_of_series
  _keys = (key for key, value of $scope.listOfSeries)
  $scope.talk.series_id = _keys[0]

  $scope.talk.language = "en"

  #uploadProgress
  $scope.uploadProgress = "0.00%"
  #ionicloading uploading template
  if $window.ionic.Platform.isAndroid()
    condTemplate = '<ion-spinner icon="android"'
    condTemplate += 'class="spinner-assertive"' if $window.ionic.Platform.grade is "a"
    condTemplate += '></ion-spinner> <br/> <strong>{{uploadProgress}}</strong> <br/> uploaded...'
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
    s3_audio_upload_url = Settings.endpoints().upload
    talk_create_url = "#{Settings.endpoints().api}/api/uploads"

    #upload options
    options = {}
    options.fileKey = "file"
    options.fileName = TalkToUpload.filename
    options.chunkedMode = no
    options.mimeType = "audio/wav" if $window.ionic.Platform.isIOS()
    options.mimeType = "audio/amr" if $window.ionic.Platform.isAndroid()
    optParams = {}
    optParams.key = $window.sha1 "#{TalkToUpload.filename}:#{$localstorage.get 'user_email'}:#{$window.Math.random()*1337%1111}"
    options.params = optParams

    if $window.ionic.Platform.isIOS()
      source = $window.cordova.file.documentsDirectory + "talks/#{TalkToUpload.filename}"
    if $window.ionic.Platform.isAndroid()
      source = TalkToUpload.nativeURL

    #state params
    params =
      talkToShareId: TalkToUpload.id

    #native upload
    #
    #show the talk uploading modal
    $ionicLoading.show ionicLoadingOpts
    #start the upload process
    uploadingPromise = $cordovaFileTransfer.upload s3_audio_upload_url, source, options
    uploadingPromise.then((success) ->
      $ionicLoading.hide()
      #ionicloading metadata uploading template
      if $window.ionic.Platform.isAndroid()
        condTemplateMeta = '<ion-spinner icon="android"'
        condTemplateMeta += 'class="spinner-assertive"' if $window.ionic.Platform.grade is "a"
        condTemplateMeta += '></ion-spinner> <br/> uploading form data...'
      if $window.ionic.Platform.isIOS()
        condTemplateMeta = '<ion-spinner icon="ios"></ion-spinner> <br/> uploading form data...'
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
        "series_id": $scope.talk.series_id
        "duration": $scope.talk.duration.substring 3, 5
      #send metadata to VR Backend
      $http.post(talk_create_url, {talk: payload})
      .success (data, status) ->
        $ionicLoading.hide()
        $cordovaToast.showShortBottom "Talk upload successfull!"
        shareUrl = "#{Settings.endpoints().api}/talks/"
        #save slug etc.
        TalkFactory.setTalkUploaded $scope.talk, shareUrl + data.slug
        $state.go "tab.share", params
      .error (data, status) ->
        msg = "Could not create the talk:\r" + data.errors
        $cordovaToast.showShortBottom(msg)
        .then ->
          $ionicLoading.hide()
    (err) ->
      $cordovaToast.showShortBottom("Could not upload the talk, please try again")
      .then ->
        #workaround to hide loading modal after error.. it only works if wrapped in promise
        $ionicLoading.hide()
    (progress) ->
      upProgress = (progress.loaded / progress.total) * 100
      upProgress = $window.Math.round((upProgress + 0.00001) * 100) / 100
      $scope.uploadProgress = "#{upProgress}%"
    )


angular.module("voicerepublic").controller("uploadCtrl", uploadCtrlFn)
