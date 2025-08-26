// When we need to draw a box shape, we can use container
import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: Home());}
} 

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // We need to use Scaffold to display containers
    return Scaffold(
      appBar: AppBar(title: const Text('Container Demo'),),
      // https://api.flutter.dev/flutter/widgets/Container-class.html
      body: Center(
        child: Column(
          children: <Widget>[RedBox(), RedBox()],
        ),
      ),
    );
  }
}

class RedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(50.0), 
      margin: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(),
      ),
    );
  }
}
