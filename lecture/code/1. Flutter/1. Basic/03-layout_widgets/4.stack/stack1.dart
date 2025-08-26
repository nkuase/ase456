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
      // Stack stacks children at the same location
      body:  Stack(
        children: [
          Container(
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
          const Text("Hello"),
        ],
      ),
    );
  }
}
