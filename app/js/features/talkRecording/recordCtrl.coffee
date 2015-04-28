angular.module("voicerepublic")

.controller "recordCtrl", ($scope, $state, $timeout, $ionicHistory, $ionicLoading, $cordovaToast, Recorder) ->
	#clear History after login
	$ionicHistory.clearHistory() 
	
	#overlay options 
	opts =
		templateUrl : "templates/recordingTemplate.html"
		scope: $scope

	$scope.isRecording = no
	$scope.isMuted = no

	$scope.start = () ->
		$scope.isRecording = yes
		
		#show the overlay
		$ionicLoading.show opts
		#notify timer directive
		$scope.$broadcast "timer-start"
		#start the recorder
		Recorder.start()

		$cordovaToast.showLongBottom("Recording started: Feel free to start your talk!")
		.then(() ->
			#success
		() ->
			#error
		)

	$scope.stop = () ->
		$scope.isRecording = no

		#notify timer directive
		$scope.$broadcast "timer-stop"
		#hide the overlay
		$ionicLoading.hide()
		#stop the recorder
		Recorder.stop()

		#show question for uploading => if true show metadata form
		#but now we go to the list TODO: add animation
		$timeout () ->
			$state.go("tab.talkList", {
			    reload: true
			})
		, 1000

	$scope.mute = () ->
		$scope.isMuted = !$scope.isMuted #toggle
		toastText = if $scope.isMuted then "Recorder muted" else "Recorder unmuted"

		#mute / unMute the recording
		if $scope.isMuted then Recorder.mute() else Recorder.unMute()

		$cordovaToast.showLongBottom( toastText )
		.then(() ->
			#success
		() ->
			#error
		)

