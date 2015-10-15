angular.module('ionic-pullup', [])
  .constant('ionPullUpFooterStatus', {
      DEFAULT: -1,
      MINIMIZED: 0,
      EXPANDED: 1
  })
  .directive('ionPullUpFooter', ['$timeout', '$rootScope', '$window', function($timeout, $rootScope, $window) {
      return {
          restrict: 'AE',
          scope: {
              onExpand: '&',
              onCollapse: '&',
              onMinimize: '&',
              minimize: '=',
              maxHeight: '=?',
              defaultHeight: '=?'
          },
          controller: ['$scope', '$element', function($scope, $element) {
              var FooterStatus = {
                  DEFAULT: -1,
                  MINIMIZED: 0,
                  EXPANDED: 1
              };
              var
                tabs = document.querySelector('.tabs'),
                hasBottomTabs = document.querySelector('.tabs-bottom'),
                header = document.querySelector('div[nav-bar="active"] .bar-header'),
                tabsHeight = tabs ? tabs.offsetHeight : 0,
                headerHeight = header ? header.offsetHeight : 64,
                handleHeight = 0,
                footer = {
                  height: 0,
                  posY: 0,
                  lastPosY: 0,
                  status: FooterStatus.DEFAULT
                };

              $scope.maxHeight = parseInt($scope.maxHeight, 10) || 0;
              $scope.defaultHeight = $element[0].offsetHeight;

              function init() {
                  $element.css({'-webkit-backface-visibility': 'hidden', 'backface-visibility': 'hidden', 'transition': '300ms ease-in-out', 'padding': 0});
                  if (tabs && hasBottomTabs) {
                      $element.css('bottom', tabs.offsetHeight + 'px');
                  }
              }

              //dibran: removed handleHeight
              function computeHeights() {
                  footer.height = $scope.maxHeight > 0 ? $scope.maxHeight : $window.innerHeight - headerHeight - tabsHeight;
                  footer.lastPosY = (tabs && hasBottomTabs) ? footer.height - tabsHeight : footer.height - $scope.defaultHeight;

                  $element.css({'height': footer.height + 'px',
                      '-webkit-transform': 'translate3d(0, ' + footer.lastPosY  + 'px, 0)',
                      'transform': 'translate3d(0, ' + footer.lastPosY  + 'px, 0)'
                  });
              }

              function expand() {
                  footer.lastPosY = 0;
                  $element.css({'-webkit-transform': 'translate3d(0, 0, 0)', 'transform': 'translate3d(0, 0, 0)'});
                  $scope.onExpand();
                  footer.status = FooterStatus.EXPANDED;
              }

              function collapse() {
                  footer.lastPosY = (tabs && hasBottomTabs) ? footer.height - tabsHeight : footer.height - $scope.defaultHeight;
                  $element.css({'-webkit-transform': 'translate3d(0, ' + footer.lastPosY  + 'px, 0)', 'transform': 'translate3d(0, ' + footer.lastPosY  + 'px, 0)'});
                  $scope.onCollapse();
                  footer.status = FooterStatus.DEFAULT
              }

              function minimize() {
                  footer.lastPosY = footer.height;
                  $element.css({'-webkit-transform': 'translate3d(0, ' + footer.lastPosY  + 'px, 0)', 'transform': 'translate3d(0, ' + footer.lastPosY  + 'px, 0)'});
                  $scope.onMinimize();
                  footer.status = FooterStatus.MINIMIZED;
              }


              this.setHandleHeight = function(height) {
                  handleHeight = height;
                  computeHeights();
              };

              this.getHeight = function() {
                  return $element[0].offsetHeight;
              };

              this.getBackground = function() {
                return $window.getComputedStyle($element[0]).background;
              };

              this.onTap = function(e) {
                  e.gesture.srcEvent.preventDefault();
                  e.gesture.preventDefault();

                  if (footer.status == FooterStatus.DEFAULT) {
                      if ($scope.minimize) {
                          minimize();
                      } else {
                          expand();
                      }
                  } else {
                      if (footer.status == FooterStatus.MINIMIZED) {
                          if ($scope.minimize)
                              collapse();
                          else
                              expand();
                      } else {
                          if ($scope.minimize)
                              minimize();
                          else
                              collapse();
                      }
                  }

                  $rootScope.$broadcast('ionPullUp:tap', footer.status);
              };

              this.onDrag = function(e) {
                  e.gesture.srcEvent.preventDefault();
                  e.gesture.preventDefault();

                  switch (e.type) {
                      case 'dragstart':
                          $element.css('transition', 'none');
                          break;
                      case 'drag':
                          footer.posY = Math.round(e.gesture.deltaY) + footer.lastPosY;
                          if (footer.posY < 0 || footer.posY > footer.height) return;
                          $element.css({'-webkit-transform': 'translate3d(0, ' + footer.posY + 'px, 0)', 'transform': 'translate3d(0, ' + footer.posY + 'px, 0)'});
                          break;
                      case 'dragend':
                          $element.css({'transition': '300ms ease-in-out'});
                          footer.lastPosY = footer.posY;
                          break;
                  }
              };

              $window.addEventListener('orientationchange', function() {
                    footer.status != FooterStatus.DEFAULT && collapse();
                    $timeout(function() {
                        computeHeights();
                    }, 500);
              });

              //dibran: fix transition from login state to bookmarks
              $timeout(function() {
                  if ($window.location.href.search('true') !== -1){
                    header = document.querySelector('div[nav-bar="active"] .bar-header');
                    headerHeight = header ? header.offsetHeight : 64;
                    computeHeights();
                  };
              }, 1000);

              init();
          }],
          compile: function(element, attrs) {
              attrs.defaultHeight && element.css('height', parseInt(attrs.defaultHeight, 10) + 'px');
              element.addClass('bar bar-footer');
          }
      }
  }])
  .directive('ionPullUpContent', [function() {
      return {
          restrict: 'AE',
          require: '^ionPullUpFooter',
          link: function (scope, element, attrs, controller) {
              var
                footerHeight = controller.getHeight();
              element.css({'display': 'block', 'margin-top': footerHeight + 'px', width: '100%'});
              // add scrolling if needed
              if (attrs.scroll && attrs.scroll.toUpperCase() == 'TRUE') {
                  element.css({'overflow-y': 'scroll', 'overflow-x': 'hidden'});
              }
          }
      }
  }])
  .directive('ionPullUpBar', [function() {
      return {
          restrict: 'AE',
          require: '^ionPullUpFooter',
          link: function (scope, element, attrs, controller) {
              var
                footerHeight = controller.getHeight();
              element.css({'display': 'flex', 'height': footerHeight + 'px', position: 'absolute', right: '0', left: '0'});

          }
      }
  }])
  .directive('ionPullUpTrigger', ['$ionicGesture', function($ionicGesture) {
      return {
          restrict: 'AE',
          require: '^ionPullUpFooter',
          link: function (scope, element, attrs, controller) {
              // add gesture
              $ionicGesture.on('tap', controller.onTap, element);
              $ionicGesture.on('drag dragstart dragend', controller.onDrag, element);
          }
      }
  }])
  .directive('ionPullUpHandle', ['$ionicGesture', '$timeout', '$window',  function($ionicGesture, $timeout, $window) {
      return {
          restrict: 'AE',
          require: '^ionPullUpFooter',
          link: function (scope, element, attrs, controller) {
              var height = parseInt(attrs.height,10) || 25, width = parseInt(attrs.width, 10) || 100,
                background =  controller.getBackground(),
                toggleClasses = attrs.toggle;

              controller.setHandleHeight(height);

              element.css({
                  display: 'block',
                  background: background,
                  position: 'absolute',
                  top: 1-height + 'px',
                  left: (($window.innerWidth - width) / 2) + 'px',
                  height: height + 'px',
                  width: width + 'px',
                  //margin: '0 auto',
                  'text-align': 'center'
                  });

              // add gesture
              $ionicGesture.on('tap', controller.onTap, element);
              $ionicGesture.on('drag dragstart dragend', controller.onDrag, element);

              scope.$on('ionPullUp:tap', function() {
                  element.find('i').toggleClass(toggleClasses);
              });

              $window.addEventListener('orientationchange', function() {
                  $timeout(function() {
                      element.css('left', (($window.innerWidth - width) / 2) + 'px');
                  }, 500);
              });
          }
      }
  }]);