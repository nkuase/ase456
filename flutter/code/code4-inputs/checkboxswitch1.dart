import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: CheckRadioSwitchPage());}
} 

class CheckRadioSwitchPage extends StatefulWidget {
  @override
  _CheckRadioSwitchPageState createState() => _CheckRadioSwitchPageState();
}

class _CheckRadioSwitchPageState extends State<CheckRadioSwitchPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkbox / Radio / Switch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    // To remove this error message
                    // value of type 'bool?' can't be assigned to a variable of type 'bool'.
                    _isChecked = value ?? false;
                  });
                },
              ),
              SizedBox(
                height: 40,
              ),
              Switch(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

