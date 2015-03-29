angular.module("voicerepublic")

.controller "loginCtrl", ($scope, $window) ->
	# log the user in and preset recording view
	$scope.login = () ->
		$window.location = "#/tab/record"