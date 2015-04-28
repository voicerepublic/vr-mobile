angular.module("voicerepublic")

.controller "talkListCtrl", ($rootScope, $scope, $window, $cordovaToast, TalkFactory, Player) ->
    $scope.isPlayingId = ""
    #data from Factory
    $rootScope.$on '$viewContentLoading', (event, viewConfig) ->
        $scope.talksToUpload = TalkFactory.getAllTalks()

    $scope.uploadedTalks = []
    #list options
    $scope.shouldShowDelete = false
    $scope.listCanSwipe = true
    #list buttons
    $scope.delete = (talk) ->
        TalkFactory.deleteTalk talk
    $scope.upload = (talk) ->
        alert 'Upload file: ' + talk.title
    $scope.play = (talk) ->
        Player.start talk
        $scope.isPlayingId = talk.id

        $cordovaToast.showLongBottom("Playing Talk " + talk.id)
        .then(() ->
            #success
        () ->
            #error
        )
    $scope.stopPlaying = () ->
        Player.stop()
        $scope.isPlayingId = ""