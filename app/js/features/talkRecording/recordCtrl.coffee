angular.module("voicerepublic")

.controller "recordCtrl", ($scope, $interval, $log, $ionicLoading) ->
	stopCounter = undefined
	$scope.isRecording = no
	$scope.isMuted = no
	$scope.recordTime = ""
	# private functions
	displayCount = (upper = "00", lower = "00") ->
		"#{upper}:#{lower}"
	opts =
		templateUrl : "templates/recordingTemplate.html"
		scope: $scope
	# end private functions
	
	$scope.record = do ->
		seconds = 0
		minutes = 0

		start : ->
			unless angular.isDefined stopCounter
				$ionicLoading.show opts
				$scope.isRecording = yes
				$scope.recordTime = displayCount()
				stopCounter = $interval ->
					lower = ++seconds + ""
					upper = if bool=seconds % 60 is 0 then (upper = ++minutes + "") else upper
					lower = "0" + lower if seconds in [1,2,3,4,5,6,7,8,9]
					lower = "0" + seconds = 0 if bool
					upper = "0" + minutes if minutes in [1,2,3,4,5,6,7,8,9]
					$scope.record.stop() if minutes == 60 #need more than 60 min? is this a Usecase?
					$scope.recordTime = displayCount upper, lower
				, 1000
		mute : -> $scope.isMuted = !$scope.isMuted
		stop : ->
			#stop recording here
			if angular.isDefined stopCounter
				$interval.cancel stopCounter
				stopCounter = undefined
				$scope.isRecording = no
				$scope.record.reset()
				$ionicLoading.hide()
		reset : ->
			#reset recording here / delete file
			seconds = 0
			minutes = 0

	$log.debug($scope.record.start) #start should be a function