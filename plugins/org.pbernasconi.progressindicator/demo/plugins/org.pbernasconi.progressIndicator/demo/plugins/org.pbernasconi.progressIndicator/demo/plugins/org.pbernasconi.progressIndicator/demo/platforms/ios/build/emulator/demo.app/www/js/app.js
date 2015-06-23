angular.module('starter', ['ionic'])

  .run(function ($ionicPlatform) {
    $ionicPlatform.ready(function () {

      if (window.cordova && window.cordova.plugins.Keyboard) {
        cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      }
      if (window.StatusBar) {
        StatusBar.styleDefault();
      }
    });
  })

  .controller('AppCtrl', function ($scope, $timeout) {
    console.log('AppCtrl');

    $scope.loadActivityIndicator = function (type) {
      switch (type) {
        case  'indeterminate-simple':
          ActivityIndicator.show('indeterminate-simple', false);
          break;
        case  'indeterminate-label':
          ActivityIndicator.show('indeterminate-label', false, 'custom Label');
          break;
        case  'indeterminate-label-detail':
          ActivityIndicator.show('indeterminate-label', false, 'custom Label', 'custom detail');
          break;
        case  'determinate-simple':
          ActivityIndicator.show('determinate-simple', false);
          break;
        case  'determinate-annular':
          ActivityIndicator.show('determinate-annular', false);
          break;
        case  'determinate-bar':
          ActivityIndicator.show('determinate-bar', false);
          break;
        case 'success':
          ActivityIndicator.show('success', false);
          break;

      }
    }
  });
