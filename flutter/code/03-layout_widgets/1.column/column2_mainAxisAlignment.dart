import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: Home());}
} 

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      // Check all the options: 
      //   center, start, end, between, around
      // mainAxis in the column is the depth of a column
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          Text("Hello"),
          Text("Flutter"),
      ],
    );
  }
}
