import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/63711034/a-value-of-type-themedata-cant-be-returned-from-method-build-because-it-has
final mainTheme = ThemeData(
  primarySwatch: Colors.purple,
  fontFamily: 'Quicksand',
  textTheme: ThemeData.light().textTheme.copyWith(
    titleMedium: TextStyle(
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    labelLarge: TextStyle(color: Colors.white),
  ),
  appBarTheme: AppBarTheme(
    toolbarTextStyle: ThemeData.light()
      .textTheme
      .copyWith(
        titleLarge: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      )
      .bodyMedium,
    titleTextStyle: ThemeData.light()
      .textTheme
      .copyWith(
        titleLarge: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      )
      .titleLarge,
  )
);

// We can use ThemeData()
//https://docs.flutter.dev/release/breaking-changes/theme-data-accent-properties
//  final ThemeData theme = ThemeData();