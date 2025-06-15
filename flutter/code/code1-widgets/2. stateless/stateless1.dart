import 'package:flutter/material.dart';

// runApp executes any Widget
// StatelessWidget.build() returns Widget (Text in this example)
void main() => runApp(MaterialApp(home:MyApp())); 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ignore the ugly font and undelined text
    return Text('Hello, ASE 456 Students');
  }
} 