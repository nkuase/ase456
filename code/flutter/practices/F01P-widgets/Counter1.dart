import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // key is used for identification, so ignore it for now
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage(title: 'Flutter Demo Home Page'),);
  }
}

// This is a pattern that every StatefulWidget uses
// So, just understand and memorize it
class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// All the variables (states) are in this class
// This is a private class. 
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // We should make a function with setState() method
  // when we need to update Dart UI 
  void _incrementCounter() {
    setState(() {_counter++;}); // Notify Dart UI to update screen
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold has three elements abf
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Text('$_counter'),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
