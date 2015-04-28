angular.module("voicerepublic")

.controller "loginCtrl", ($scope, $window, $state) ->
	# log the user in and preset recording view
	$scope.login = () ->
		$state.go 'tab.record'