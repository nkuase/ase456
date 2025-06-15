import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:MyApp())); 

class MyApp extends StatefulWidget {
  const MyApp(); 
  @override
  State<MyApp> createState() => _MyAppState();
}

// All the variables (states) are in this class
// This is a private class. 
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Text('Hello, ASE 456 Students');
  }
} 