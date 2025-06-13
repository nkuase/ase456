import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: ElevatedButtonPage());}
} 

class ElevatedButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ElevatedButtonPage'),
      ),
      body: Center(
        child:
        ElevatedButton(
          child: const Text('ElevatedButton'),
          onPressed: () {},
        ),
      ),
    );
  }
}

