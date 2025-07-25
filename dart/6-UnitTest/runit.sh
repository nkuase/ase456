#!/bin/env bash


# This script is used to run unit tests for Dart files in the project.
# It will execute the tests in the specified Dart files and print the results.
# Ensure you have the Dart SDK installed and configured in your environment.
# dart pub get
# dart pub upgrade
dart test
dart test test
dart test test/arith_test.dart
dart test/arith_test.dart 

dart test -r expanded
dart test -n "should add two positive numbers"