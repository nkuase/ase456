import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: Home());}
} 

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Container Demo'),),
      body: Align(
        // options: bottomLeft, bottomCenter, bottomRight
        //          centerLeft, center, centerRight
        //          topLeft, top, topRight
        alignment: Alignment.bottomRight,
        child: Container(
          height: 80,
          width: 200,
          color: Colors.blueGrey,
          alignment: Alignment.center,
          child: const Text(
            "Text Inside a Container",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}


