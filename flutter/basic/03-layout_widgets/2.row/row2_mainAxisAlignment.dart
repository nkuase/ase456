import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: Home());}
} 

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      // Check all the options 
      // center, start, end, spaceAround, spaceBetween, and spaceAround
      // https://flutteragency.com/how-to-set-space-between-elements-in-flutter/
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          Text("Hello"),
          Text("Flutter"),
      ],
    );
  }
}
