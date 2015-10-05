###
@ngdoc controller
@name bookmarksCtrl

@function

@description
  This Controller is responsible for the bookmarks overview.
  It uses the following services & factories:
  - Fetcher
  - Player

  **Note:** 
  Using the following cordova plugins:
  - cordova.toast
###
angular.module("voicerepublic")

.controller "bookmarksCtrl", ($scope, $state, $stateParams, $window, $timeout, $interval, $ionicHistory, $ionicLoading, $ionicPopup, $cordovaSocialSharing, $cordovaToast, Auth, Fetcher, Player) ->
  #bookmark container
  $scope.bookmarks = []

  #played talks container
  $scope.playedTalk = null

  #flags
  $scope.isIOS = $window.ionic.Platform.isIOS()
  $scope.isTalkPlaying = no
  $scope.isTalkPaused = no
  $scope.isFooterExpanded = no
  $scope.isRefresh = no
  $scope.isInfScroll = no
  $scope.isTalkLoading = no
  progressChangedFromUser = no

  #ionic loading template
  if $window.ionic.Platform.isAndroid()
    condTemplate = '<ion-spinner icon="android"'
    condTemplate += 'class="spinner-assertive"' if $window.ionic.Platform.grade is "a"
    condTemplate += '></ion-spinner> <br/> Loading...'
  if $window.ionic.Platform.isIOS()
    condTemplate = '<ion-spinner icon="ios"></ion-spinner> <br/> Loading...'
  ionicLoadingOpts =
    template: condTemplate
    hideOnStateChange: yes

  #events
  #
  #fetched the bundle successfully
  Fetcher.on 'bundleLoaded', (talks) ->
    $scope.bookmarks = [] if $scope.isRefresh
    for talk in talks
      talk.url = "#{Fetcher.baseUrl}#{talk.media_links.mp3}"
      console.log talk
      $scope.bookmarks.push talk
    $scope.$broadcast 'scroll.infiniteScrollComplete' if $scope.isInfScroll
    $scope.$broadcast 'scroll.refreshComplete' if $scope.isRefresh
    $scope.isRefresh = no
    $scope.isInfScroll = no

  #error fetching bundle
  Fetcher.on 'error', (err) ->
    $scope.isRefresh = no
    $scope.isInfScroll = no
    console.log JSON.stringify err

  #loading resource
  Player.on 'loadStart', () ->
    #show the loading modal
    if $scope.isFooterExpanded
      $ionicLoading.show ionicLoadingOpts
    $scope.isTalkLoading = yes
    console.log 'Loading...'

  #resource loaded
  Player.on 'loadEnd', () ->
    #hide the loading modal
    $ionicLoading.hide() if $scope.isFooterExpanded
    $scope.isTalkLoading = no
    console.log 'Done loading!'

  #update the duration of the played talk
  Player.on 'duration', (duration) ->
    duration = Math.floor parseInt duration, 10
    $scope.playedTalk.duration = duration

  #update the progress of the played talk
  Player.on 'progress', (progress) ->
    if progressChangedFromUser
      progressChangedFromUser = no
      return
    progress = Math.floor parseInt progress, 10
    $scope.playedTalk.progress = progress

  #something went wrong while playing
  Player.on 'error', (err) ->
    $scope.isTalkLoading = no
    console.log JSON.stringify err

  #Bookmarked talks list relevant
  #
  $scope.refreshBookmarks = () ->
    $scope.isRefresh = yes
    Fetcher.refresh()

  $scope.moreDataCanBeLoaded = () ->
    Fetcher.canLoadMore

  $scope.loadMore = () ->
    $scope.isInfScroll = yes
    Fetcher.loadNextBundle()

  #Footer handle
  #
  $scope.footerExpand = () ->
    handleButton = $window.document.querySelector '#handle-button'
    hasPauseButton = handleButton.classList.contains 'ion-ios-pause'
    hasPlayButton = handleButton.classList.contains 'ion-ios-play'

    if hasPlayButton
      handleButton.classList.remove 'ion-ios-play'
    else if hasPauseButton
      handleButton.classList.remove 'ion-ios-pause'

    handleButton.classList.add 'ion-close'

    if $scope.isTalkLoading
      $ionicLoading.show ionicLoadingOpts

    $scope.isFooterExpanded = yes


  $scope.footerCollapse = () ->
    handleButton = $window.document.querySelector '#handle-button'
    hasCloseButton = handleButton.classList.contains 'ion-close'

    if !$scope.isTalkPaused and hasCloseButton
      handleButton.classList.remove 'ion-close'
      handleButton.classList.add 'ion-ios-pause'
    else if $scope.isTalkPaused and hasCloseButton
      handleButton.classList.remove 'ion-close'
      handleButton.classList.add 'ion-ios-play'

    $scope.isFooterExpanded = no

  $scope.changeChevron = ($e) ->
    el = $e.target
    if el.classList.contains 'ion-chevron-up'
      el.classList.remove 'ion-chevron-up'
      el.classList.add 'ion-chevron-down'
    else if el.classList.contains 'ion-chevron-down'
      el.classList.remove 'ion-chevron-down'
      el.classList.add 'ion-chevron-up'

  #Player relevant
  #
  $scope.play = (talk, index) ->
    isSame = talk.id is $scope.playedTalk?.id
    isSameAndPlaying = isSame and $scope.isTalkPlaying
    shouldResume = isSame and $scope.isTalkPaused
    #handle if talk is paused
    $scope.resume() if shouldResume
    #nothing to do if same talk
    return if isSameAndPlaying
    #if one is playing stop it to start the new
    if $scope.isTalkPlaying
    #handle via event
      Player.once 'stopped', () ->
        play talk, index
      Player.stop()
    else
      play talk, index

  #handle playing event-based -> wait for stop
  play = (talk, index) ->
    #remove event listener after handled
    Player.off 'stopped'
    #assure button icon
    el = $window.document.querySelector '#pauseOrResume-button'
    if el.classList.contains 'ion-ios-play'
      el.classList.remove 'ion-ios-play'
      el.classList.add 'ion-ios-pause'
    el = $window.document.querySelector '#handle-button'
    if el.classList.contains 'ion-ios-play'
      el.classList.remove 'ion-ios-play'
      el.classList.add 'ion-ios-pause'
    $scope.playedTalk = talk
    #reset progress & duration
    $scope.playedTalk.progress = 0
    $scope.playedTalk.duration = 0
    #assign index to know which is next or last
    $scope.playedTalk.index = index
    Player.start talk
    $scope.isTalkPlaying = yes
    Player.once 'stopped', () ->
      alternateButtons()
      Player.off 'stopped'
      progress = $scope.playedTalk.progress
      duration = $scope.playedTalk.duration
      if progress >= duration
        $scope.isTalkPlaying = no
        $scope.playNext()
      else
        $scope.isTalkPlaying = no

  $scope.pause = () ->
    $scope.isTalkPaused = yes
    Player.pause()

  $scope.resume = () ->
    $scope.isTalkPaused = no
    Player.play()

  $scope.sliderReleased = () ->
    progressChangedFromUser = yes
    pos = $scope.playedTalk.progress
    Player.seekTo pos * 1000

  $scope.stop = () ->
    $scope.isTalkPlaying = no
    Player.stop()
    # wait for view to settle
    $timeout ->
      $scope.playedTalk = null
    , 300

  alternateButtons = () ->
    handleButton =
      target: $window.document.querySelector '#handle-button'
    pauseOrResumeButton =
      target: $window.document.querySelector '#pauseOrResume-button'
    alternateButtonFromTarget pauseOrResumeButton
    alternateButtonFromTarget handleButton

  alternateButtonFromTarget = ($e) ->
    el = $e.target
    if el.classList.contains 'ion-ios-pause'
      el.classList.remove 'ion-ios-pause'
      el.classList.add 'ion-ios-play'
    else if el.classList.contains 'ion-ios-play'
      el.classList.remove 'ion-ios-play'
      el.classList.add 'ion-ios-pause'

  $scope.pauseOrResume = ($e) ->
    el = $e.target

    if el.classList.contains 'ion-ios-pause'
      $scope.pause() if $scope.isTalkPlaying
    else if el.classList.contains 'ion-ios-play'
      if $scope.isTalkPaused
        $scope.resume()
      else if not $scope.isTalkPlaying
        $scope.play $scope.playedTalk, $scope.playedTalk.index

    alternateButtonFromTarget $e

  $scope.handleAction = () ->
    handleButton =
      target: $window.document.querySelector '#handle-button'
    pauseOrResumeButton =
      target: $window.document.querySelector '#pauseOrResume-button'

    if $scope.isFooterExpanded
      $scope.stop()
    else
      $scope.pauseOrResume handleButton
      alternateButtonFromTarget pauseOrResumeButton
    
  getNextOrLastTalk = (backward = false) ->
    index = $scope.playedTalk.index
    last = $scope.bookmarks.length - 1
    first = 0
    if backward
      next = index - 1
      if index is first
        next = last
    else
      next = index + 1
      if index is last
        next = first
    nextTalk = $scope.bookmarks[next]
    nextTalk.index = next
    return nextTalk

  $scope.playNext = () ->
    nextTalk = getNextOrLastTalk()
    $scope.play nextTalk, nextTalk.index

  $scope.playLast = () ->
    backward = yes
    lastTalk = getNextOrLastTalk backward
    $scope.play lastTalk, lastTalk.index

  #Load the share context
  #
  $scope.share = (talk) ->
    #shared stuff
    file = null
    message = talk.teaser
    subject = talk.title
    link = talk.self_url

    $cordovaSocialSharing
    .share(message, subject, file, link)
    .then((result) ->
      #share context opened
    (error) ->
      #something went wrong
    )

  #swipe actions
  #
  #swiped left
  $scope.onSwipedLeft = () ->
    if $scope.isTalkPlaying
      $scope.stop()
    $state.go "tab.record"

  #Logout
  $scope.logOut = () ->
    nextViewOpts =
      disableBack: yes
      historyRoot: yes
    $ionicHistory.nextViewOptions nextViewOpts
    popupOpts =
      title: "Logout"
      template: "Do you really want to log out?"
      cancelText: "No"
      okText: "Yes"
      okType: "button-assertive"
    popupPromise = $ionicPopup.confirm popupOpts
    popupPromise.then (logout) ->
      if logout
        Auth.setAuthToken null, null
        $state.go "login"
