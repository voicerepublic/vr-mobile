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

.controller "bookmarksCtrl", ($rootScope, $scope, $state, $stateParams, $window, $timeout, $ionicHistory, $ionicPopup, $cordovaSocialSharing, $cordovaToast, Auth) ->
  #mockup data
  $scope.bookmarks = [
    talk1 =
      img: 'http://lorempixel.com/800/700'
      teaser: 'teasing you - for ever'
      participants: 'Mark Teaser, Tea Ser'
      title: 'lorem ipsum'
      isDownloaded: yes
      description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
    talk2 =
      img: 'http://lorempixel.com/800/700'
      teaser: 'teasing you - for ever'
      participants: 'Mark Teaser, Tea Ser'
      title: 'lorem ipsum'
      description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
    talk3 =
      img: 'http://lorempixel.com/800/700'
      teaser: 'teasing you - for ever'
      participants: 'Mark Teaser, Tea Ser'
      title: 'lorem ipsum'
      description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
  ]

  #Variables ?needed
  $scope.isIOS = $window.ionic.Platform.isIOS()
  $scope.playedTalk = {}
  $scope.isTalkPlaying = no
  $scope.isTalkPaused = no
  $scope.isFooterExpanded = no

  #Bookmarked talk list relevant
  #
  $scope.refreshBookmarks = () ->
    #$scope.bookmarks = Fetcher.refresh()
    talk4 =
      img: 'http://lorempixel.com/800/700'
      teaser: 'teasing you - for ever'
      participants: 'Mark Teaser, Tea Ser'
      title: 'lorem ipsum'
      isDownloaded: yes
      description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
 
    $timeout ->
      $scope.bookmarks.unshift talk4
      $scope.$broadcast 'scroll.refreshComplete'
    , 1337

  $scope.moreDataCanBeLoaded = () ->
    yes

  $scope.loadMore = () ->
    #nextBundle = Fetcher.loadNextBundle()
    talk1 =
      img: 'http://lorempixel.com/800/700'
      teaser: 'teasing you - for ever'
      participants: 'Mark Teaser, Tea Ser'
      title: 'lorem ipsum'
      description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
    talk2 =
      img: 'http://lorempixel.com/800/700'
      teaser: 'teasing you - for ever'
      participants: 'Mark Teaser, Tea Ser'
      title: 'lorem ipsum'
      description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
    talk3 =
      img: 'http://lorempixel.com/800/700'
      teaser: 'teasing you - for ever'
      participants: 'Mark Teaser, Tea Ser'
      title: 'lorem ipsum'
      description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
    talk4 =
      img: 'http://lorempixel.com/800/700'
      teaser: 'teasing you - for ever'
      participants: 'Mark Teaser, Tea Ser'
      title: 'lorem ipsum'
      description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
 
    $timeout ->
      $scope.bookmarks.push talk1
      $scope.bookmarks.push talk2
      $scope.bookmarks.push talk3
      $scope.bookmarks.push talk4
      $scope.$broadcast 'scroll.infiniteScrollComplete'
    , 1337

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
  $scope.play = (talk) ->
    $scope.isTalkPlaying = yes
    $scope.playedTalk = talk

  $scope.pause = () ->
    $scope.isTalkPaused = yes

  $scope.stop = () ->
    $scope.isTalkPlaying = no
    $scope.playedTalk = null

  $scope.pauseOrResume = ($e) ->
    el = $e.target

    if el.classList.contains 'ion-ios-pause'
      el.classList.remove 'ion-ios-pause'
      el.classList.add 'ion-ios-play'
      $scope.pause() if $scope.isTalkPlaying
    else if el.classList.contains 'ion-ios-play'
      el.classList.remove 'ion-ios-play'
      el.classList.add 'ion-ios-pause'
      $scope.resume() if $scope.isTalkPaused

  $scope.resume = () ->
    $scope.isTalkPaused = no

  $scope.handleAction = () ->
    handleButton =
      target: $window.document.querySelector '#handle-button'
    pauseOrResumeButton =
      target: $window.document.querySelector '#pauseOrResume-button'

    if $scope.isFooterExpanded
      $scope.stop()
    else
      $scope.pauseOrResume handleButton
      $scope.pauseOrResume pauseOrResumeButton
    

  $scope.playNext = () ->
    $scope.playedTalk = $scope.bookmarks[2]

  $scope.playLast = () ->
    $scope.playedTalk = $scope.bookmarks[1]

  #Load the share context
  #
  $scope.share = (talk) ->
    #shared stuff
    file = null
    message = talk.description
    subject = talk.title
    link = talk.url

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
