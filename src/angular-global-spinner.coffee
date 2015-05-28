angular.module('globalSpinner', [])

angular.module('globalSpinner')
  .provider 'globalSpinner', ->
    configure: (obj = {}) ->
      @config = obj

    $get: ->
      angular.extend(
        timeout: 0
        eventStart: 'globalSpinner:start'
        eventStop: 'globalSpinner:stop'
      , @config)

  .config ($provide, $httpProvider) ->
    $provide.factory 'globalSpinnerInterceptor', (
      $q, $injector, $timeout, globalSpinner, $filter) ->

      $rootScope = $rootScope || $injector.get('$rootScope')
      spinnerTimeout = null

      hideSpinner = ->
        if spinnerTimeout
          $timeout.cancel(spinnerTimeout)
          spinnerTimeout = null
        $rootScope.$broadcast globalSpinner.eventStop

      showSpinner = ->
        # Only display the spinner if it takes more than X ms to respond to the request.
        spinnerTimeout ||= $timeout( ->
          spinnerTimeout = null
          $rootScope.$broadcast globalSpinner.eventStart
        , globalSpinner.timeout)

      noPendingRequests = ->
        $http = $http || $injector.get('$http')
        $filter('filter')($http.pendingRequests, headers: {'X-Silent-Request': undefined}).length < 1

      request: (request) ->
        showSpinner() unless request.headers['X-Silent-Request']
        request

      requestError: (request) ->
        hideSpinner() if noPendingRequests()
        $q.reject(response)

      response: (response) ->
        hideSpinner() if noPendingRequests()
        response

      responseError: (response) ->
        hideSpinner() if noPendingRequests()
        $q.reject(response)

    # enable globalSpinnerInterceptor
    $httpProvider.interceptors.push 'globalSpinnerInterceptor'
