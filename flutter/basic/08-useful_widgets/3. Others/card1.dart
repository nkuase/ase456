import 'package:flutter/material.dart';

// Widget with card shape

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: CardPage());}
} 

class CardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card'),
      ),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4.0, // shadow depth
          child: Container(
            width: 200, height: 200,
            child: Center(child: Text("Hello")),
          ),
        ),
      ),
    );
  }
}

