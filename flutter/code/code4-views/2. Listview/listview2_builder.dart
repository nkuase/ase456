import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: Home());}
} 

class Home extends StatelessWidget {
  final myList = List<int>.generate(30, (i) => i);
  @override
  Widget build(BuildContext context) {
    // The 'builder' named constructor builds a list of widgets 
    // by taking the 'myList' list as data source.
    return ListView.builder( // named constuctor
      itemCount: myList.length,
      itemBuilder: (context, index) {
        return Text("${myList[index]}");
      },
    );
  }
}
