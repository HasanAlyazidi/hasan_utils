## [1.1.0] - 2021-12-29

* Api: Added interceptors to `Api.options()`
* Upgraded dependencies

## [1.0.3] - 2021-10-21

* Storage: Added `repload()`

## [1.0.2] - 2021-10-17

* Api: Fixed sending `List` in `params`

## [1.0.1] - 2021-04-04

* Navigation: Add `replace()`

## [1.0.0] - 2021-04-01

* Null safety support

## [0.4.5] - 2020-11-30

* Api: Add `authorizationHeader` to get authorization's header (`{'Authorization': '...'}`)

## [0.4.4] - 2020-11-18

* FileDownloader: Fully asynchronize `start()`

## [0.4.3] - 2020-11-18

* FileDownloader: Make `start()` return `Future`

## [0.4.2] - 2020-10-25

* Storage: Added `setInt()`, `setDouble()`, `setBool()`

## [0.4.1] - 2020-10-21

* Api: Ensure `onFinish()` is called after `onSuccess()`

## [0.4.0] - 2020-09-29

* Api: Upload MultiPart files.

## [0.3.0] - 2020-09-17

* Updated dependencies.
* Fixed Api debug error response.

## [0.2.0] - 2020-08-30

* Fixed `FormatException` that is thrown when an `Api` request expects JSON output but response returns string instead.

## [0.1.0] - 2020-08-26

* Initial release.
