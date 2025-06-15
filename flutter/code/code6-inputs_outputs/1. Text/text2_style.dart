import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: Home());}
} 

// Remove the yellow underline
// https://stackoverflow.com/questions/47114639/yellow-lines-under-text-widgets-in-flutter
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "16 size, 3 spacing, and blue color",
      style: TextStyle(
        color: Colors.blue,
        fontSize: 16,
        wordSpacing: 3,
        decoration: TextDecoration.none,
      ),
    );
  }
}

