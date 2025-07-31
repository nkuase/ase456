import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: IconButtonPage());}
} 

class IconButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IconButton'),
      ),
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.add),
          color: Colors.red,
          iconSize: 100.0, 
          onPressed: () {},
        ),
      ),
    );
  }
}
