import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:MyApp())); 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyStateful();
  }
}

class MyStateful extends StatefulWidget {
  @override
  State<MyStateful> createState() => _MyState();
}  

class _MyState extends State<MyStateful> {
  String _str = "Hello";
  @override
  Widget build(BuildContext context) {
    return Text(_str);
  }
}
