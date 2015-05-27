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

    $scope.loadProgressIndicator = function (type) {
      switch (type) {
        case  'indeterminate-simple':
          ProgressIndicator.showSimple(true);
          timeout();
          break;
        case  'indeterminate-label':
          ProgressIndicator.showSimpleWithLabel(false, 'custom Label');
          timeout();
          break;
        case  'indeterminate-label-detail':
          ProgressIndicator.showSimpleWithLabelDetail(false, 'custom Label', 'custom detail');
          timeout();
          break;
        case  'determinate-simple':
          ProgressIndicator.showDeterminate(false);
          break;
        case  'determinate-simple-label':
          ProgressIndicator.showDeterminateWithLabel(false, 100000, 'custom label');
          break;
        case  'determinate-annular':
          ProgressIndicator.showDeterminateAnnular(false);
          break;
        case  'determinate-annular-label':
          ProgressIndicator.showDeterminateAnnularWithLabel(false, 50000, 'custom label');
          break;
        case  'determinate-bar':
          ProgressIndicator.showDeterminateBar(false, 100000);
          break;
        case  'determinate-bar-label':
          ProgressIndicator.showDeterminateBarWithLabel(false, 100000, 'custom label');
          break;
        case 'success':
          ProgressIndicator.showSuccess(false, 'success');
          timeout();
          break;
        case 'text-top':
          ProgressIndicator.showText(false, 'text at the TOP', 'top');
          timeout();
          break;
        case 'text-bottom':
          ProgressIndicator.showText(false, 'text at the BOTTOM', 'bottom');
          timeout();
          break;
      }

      function timeout() {
        $timeout(function () {
          ProgressIndicator.hide();
        }, 5000);

      }
    }
  });
