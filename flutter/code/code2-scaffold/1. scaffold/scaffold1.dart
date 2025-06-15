import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:MyApp())); 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Title'),),
      body: Text('Hello'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, 
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
} 