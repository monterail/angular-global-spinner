(function() {
  angular.module("globalSpinner", []);

  angular.module('globalSpinner').config(function($provide, $httpProvider) {
    $provide.factory('SpinnerInterceptor', [
      '$q', '$injector', function($q, $injector) {
        var $rootScope, activeRequests, checkPending, error, success;
        $rootScope = $rootScope || $injector.get('$rootScope');
        activeRequests = 0;
        $httpProvider.defaults.transformRequest.push(function(data) {
          $rootScope.$spinnerLoading = true;
          activeRequests++;
          return data;
        });
        $httpProvider.defaults.transformResponse.push(function(data) {
          activeRequests--;
          if (activeRequests === 0) {
            $rootScope.$spinnerLoading = false;
          }
          return data;
        });
        checkPending = function() {
          var $http;
          $http = $http || $injector.get('$http');
          if ($http.pendingRequests.length < 1) {
            return $rootScope.$spinnerLoading = false;
          }
        };
        success = function(response) {
          checkPending();
          return response;
        };
        error = function(response) {
          checkPending();
          return $q.reject(response);
        };
        return function(promise) {
          $rootScope.$spinnerLoading = true;
          return promise.then(success, error);
        };
      }
    ]);
    return $httpProvider.responseInterceptors.push('SpinnerInterceptor');
  });

  angular.module('globalSpinner').directive('spinner', function() {
    return {
      restrict: 'EA',
      replace: true,
      link: function(scope, element) {
        return scope.$watch("$spinnerLoading", function(v) {
          return element.css('display', v ? 'block' : 'none');
        });
      }
    };
  });

}).call(this);
