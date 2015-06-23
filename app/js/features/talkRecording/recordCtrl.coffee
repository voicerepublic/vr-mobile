angular.module("voicerepublic")

.controller "recordCtrl", ($scope, $ionicLoading, $cordovaToast, Recorder) ->
	#overlay options 
	opts =
		templateUrl : "templates/recordingTemplate.html"
		scope: $scope

	$scope.isRecording = no
	$scope.isMuted = no

	$scope.start = () ->
		$scope.isRecording = yes

		#notify timer directive
		$scope.$broadcast "timer-start"
		#show the overlay
		$ionicLoading.show opts
		#start the recorder
		Recorder.start()

		$cordovaToast.showLongBottom "Recording started: Feel free to start your talk!"

	$scope.stop = () ->
		$scope.isRecording = no

		#notify timer directive
		$scope.$broadcast "timer-stop"
		#hide the overlay
		$ionicLoading.hide()
		#stop the recorder
		Recorder.stop()

		#show question for uploading => if true show metadata form

	$scope.mute = () ->
		$scope.isMuted = !$scope.isMuted #toggle

		#mute the recording
		Recorder.mute()

		$cordovaToast.showShortBottom "Recording muted"

