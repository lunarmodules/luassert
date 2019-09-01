# Changelog

### 1.8.x unreleased

* `called_with` and `returned_with` asserts now try to show why they fail.

  This applies to spies, stubs and mocks.

  If no call matches the expected arguments or returned values are
  compared to those of the last call.

  If no call was expected to match but one or more does the expected
  arguments or returned values are compared to the last matching call.


### 1.8.0 released 28-Jun-2019
