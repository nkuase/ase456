import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: MyWidget());}
} 

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xffeeeeee),
        child: Center(
          child: Container(
            color: const Color(0xffcccccc),
            child: BlueBoxes(),
        ),
      ),
    );
  }
}

class BlueBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Try with min also
      children: [
        BlueBox(),
        BlueBox(),
        BlueBox(),
      ],
    );
  }
}

class BlueBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(),
      ),
    );
  }
}
