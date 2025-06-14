import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: DropdownPage());}
} 

class DropdownPage extends StatefulWidget {
  @override
  _DropdownPageState createState() => _DropdownPageState();
}

class _DropdownPageState extends State<DropdownPage> {
  final _valueList = ['First', 'Second', 'Third'];
  var _selectedValue = 'First';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Button'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children:[
              DropdownButton(
                value: _selectedValue,
                items: _valueList.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value as String;
                  });
                },
              ),
              SizedBox(height:100),
              Text(this._selectedValue),
            ],
          ),
        ),
      ),
    );
  }
}


