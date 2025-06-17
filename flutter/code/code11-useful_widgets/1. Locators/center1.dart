// We need to center the text in the Text.
// We have to adjust three times. 
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
      // 1. We can use Center widget to put container in the center 
      body: Center(
        child: Container(
          height: 80,
          width: 200,
          color: Colors.blueGrey,
          // 2. We can use Alignment.center to put the child (Text) 
          // in the center
          alignment: Alignment.center,
          child: const Text(
            "Text Inside a Container",
            // 3. The text in the Text can be aligned with textAlign
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
