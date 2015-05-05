(function() {
  angular.module('globalSpinner', []);

  angular.module('globalSpinner').provider('globalSpinner', function() {
    return {
      configure: function(obj) {
        if (obj == null) {
          obj = {};
        }
        return this.config = obj;
      },
      $get: function() {
        return angular.extend({
          timeout: 1000,
          eventStart: 'globalSpinner:start',
          eventStop: 'globalSpinner:stop'
        }, this.config);
      }
    };
  }).config(function($provide, $httpProvider) {
    $provide.factory('globalSpinnerInterceptor', [
      '$q', '$injector', '$timeout', 'globalSpinner', function($q, $injector, $timeout, globalSpinner) {
        var $rootScope, hideSpinner, noPendingRequests, showSpinner, spinnerTimeout;
        $rootScope = $rootScope || $injector.get('$rootScope');
        spinnerTimeout = null;
        hideSpinner = function() {
          if (spinnerTimeout) {
            $timeout.cancel(spinnerTimeout);
            spinnerTimeout = null;
          }
          return $rootScope.$broadcast(globalSpinner.eventStop);
        };
        showSpinner = function() {
          return spinnerTimeout || (spinnerTimeout = $timeout(function() {
            spinnerTimeout = null;
            return $rootScope.$broadcast(globalSpinner.eventStart);
          }, globalSpinner.timeout));
        };
        noPendingRequests = function() {
          var $http;
          $http = $http || $injector.get('$http');
          return _.reduce($http.pendingRequests, (function(sum, request) {
            if (!request.headers['X-Silent-Request']) {
              sum += 1;
            }
            return sum;
          }), 0) < 1;
        };
        return {
          request: function(request) {
            if (!request.headers['X-Silent-Request']) {
              showSpinner();
            }
            return request;
          },
          requestError: function(request) {
            if (noPendingRequests()) {
              hideSpinner();
            }
            return $q.reject(response);
          },
          response: function(response) {
            if (noPendingRequests()) {
              hideSpinner();
            }
            return response;
          },
          responseError: function(response) {
            if (noPendingRequests()) {
              hideSpinner();
            }
            return $q.reject(response);
          }
        };
      }
    ]);
    return $httpProvider.interceptors.push('globalSpinnerInterceptor');
  });

}).call(this);
