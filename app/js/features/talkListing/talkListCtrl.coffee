angular.module("voicerepublic")

.controller "talkListCtrl", ($scope, Talks) ->
    #data from service
    $scope.talksToUpload = Talks.toUpload()
    $scope.uploadedTalks = Talks.uploadedBefore()
    #list options
    $scope.shouldShowDelete = false
    $scope.listCanSwipe = true
    #list buttons
    $scope.delete = (file) ->
        alert 'Delete file: ' + file.title
    $scope.upload = (file) ->
        alert 'Upload file: ' + file.title