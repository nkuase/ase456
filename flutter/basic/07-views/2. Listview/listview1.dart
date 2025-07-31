import 'package:flutter/material.dart';

/*
A ListView is basically a Column with scrolling behavior as it places one or more children in the vertical axis, in sequence.
This widget is very widely used because it provides the possibility to scroll contents when they are bigger than the screen size.
*/

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: Home());}
} 

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
          Text("Hello"),
          // SizedBox gives space between widgets
          SizedBox(height: 200),
          Text("Flutter"),
          SizedBox(height: 200),        
          Text("Hello"),
          SizedBox(height: 200),
          Text("Flutter"),
          SizedBox(height: 200),        
      ],
    );
  }
}



