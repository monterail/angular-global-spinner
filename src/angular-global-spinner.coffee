angular.module("globalSpinner")

angular.module('globalSpinner').config ($provide, $httpProvider) ->
  $provide.factory 'SpinnerInterceptor', ['$q', '$injector', ($q, $injector) ->
    $rootScope = $rootScope || $injector.get('$rootScope')
    activeRequests = 0

    $httpProvider.defaults.transformRequest.push (data) ->
      $rootScope.$spinnerLoading = true
      activeRequests++
      data

    $httpProvider.defaults.transformResponse.push (data) ->
      activeRequests--
      $rootScope.$spinnerLoading = false if activeRequests == 0
      data

    checkPending = () ->
      $http = $http || $injector.get('$http')
      if $http.pendingRequests.length < 1
        $rootScope.$spinnerLoading = false

    success = (response) ->
      checkPending()
      response

    error = (response) ->
      checkPending()
      $q.reject(response)

    (promise) ->
      $rootScope.$spinnerLoading = true
      promise.then(success, error)
  ]

  $httpProvider.responseInterceptors.push('SpinnerInterceptor')

angular.module('globalSpinner').directive 'spinner', ->
  restrict: 'EA'
  replace: true
  link: (scope, element) ->
    scope.$watch "$spinnerLoading", (v) ->
      element.css('display', if v then 'block' else 'none')
