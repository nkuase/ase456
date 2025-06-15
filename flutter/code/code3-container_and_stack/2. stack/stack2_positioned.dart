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
      // we can use Positioned widget to move the stacked widgets
      body:  Stack(
        children: [
          Positioned(
            top: 0,
            left: 200,
            child: Container(
              height: 80,
              width: 200,
              color: Colors.blueGrey,
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
          const Positioned(
            top: 40,
            left: 65, 
            child: Text("Hello"),
          ),
        ],
      ),
    );
  }
}

