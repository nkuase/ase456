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
      body: Center(
        child: Container(
          // We can use padding and margin to give some space
          // We use EdgeInsets to make the space. 
          // https://api.flutter.dev/flutter/painting/EdgeInsets-class.html
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
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
