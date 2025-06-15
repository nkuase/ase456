import 'package:flutter/material.dart';

/*
A GridView generates a grid based on a column count
*/

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: Home());}
} 

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // count named constructor
    return Scaffold(
      body: GridView.count(
        // two column format
        crossAxisCount: 2, 
        children: <Widget>[
          Container(
            color: Colors.red,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
          ),
          Container(
            color: Colors.green,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
          ),
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
          ),                    
        ],
      ), 
    );
  }
}





