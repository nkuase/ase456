import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: TextFieldPage());}
} 

class TextFieldPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextField'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(),
              SizedBox(
                height: 40,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Input Anything',   
                ),
              ),
              SizedBox(
                height: 40,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),   // bordered outline
                  labelText: 'Input Anything',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

