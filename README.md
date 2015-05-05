angular-global-spinner
======================

Angular global HTTP spinner.

## Install

```
bower install angular-global-spinner
```

## Usage

```js
// require globalSpinner module as dependency
angular.module('myApp', ['globalSpinner']);
```

## Configuration
```js

angular.module("myApp").config (globalSpinnerProvider) ->
  globalSpinnerProvider.configure
    (
      timeout: 500 //default is 0
      eventStart: 'globalSpinner:start' //default is globalSpinner:start
      eventStop: 'globalSpinner:stop' //default is globalSpinner:stop
    )
```

You have to, however, apply your own stylesheets and event watchers.

##Example

```js

angular.module('SolarApp').directive 'spinner', (globalSpinner) ->
  link: ($scope, elem, attrs) ->
  
    $scope.$on globalSpinner.eventStart, ->
      //do the action specific for starting the spinner
    $scope.$on globalSpinner.eventStop, ->
      //do the action specific for stopping the spinner

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
