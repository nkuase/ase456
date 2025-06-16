import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: TextButtonPage());}
} 

class TextButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextButtonPage'),
      ),
      body: Center(
        child: TextButton(
          child: const Text('TextButton'),
          onPressed: () {},
        ),
      ),
    );
  }
}

