# Changelog

## 0.0.1

- Initial version with all functionalities implemented.

## 0.0.2

- Add coverage analysis through Coveralls (`tool/coveralls.sh`) and have more tests for higher coverage.
- Better readme.

## 0.0.3

- Fix issue of possibly return a `0` x coordinate as a share.
- Add in branches of code to ensure that it will be tested later on (lowering coverage).

## 0.0.4

- Remove random byte method from ByteHelper and create ByteRandom singleton to be used to generate random bytes.
- Add mocks to tests to properly test edge cases involving specific random bytes.