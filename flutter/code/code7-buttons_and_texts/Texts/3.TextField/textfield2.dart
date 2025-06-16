import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return const MaterialApp(home: TextFieldPage(title:'TextField'));}
} 

class TextFieldPage extends StatefulWidget {
  const TextFieldPage({required this.title});
  final String title;

  @override
  State<TextFieldPage> createState() => _TextFieldPageState();
}


class _TextFieldPageState extends State<TextFieldPage> {
  late String _string = 'Hello World';

  void _updateString(String newString) {
    setState(() {_string = newString;}); // Notify Dart UI to update screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_string'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),   // bordered outline
                  labelText: 'Input Anything',
                ),
                onChanged: (text) {_updateString(text);},
              ),
            ],
          ),
        ),
      ),
    );
  }
}



