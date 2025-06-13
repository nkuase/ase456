import 'package:flutter/material.dart';

enum Gender { MAN, WOMEN }

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: RadioPage());}
} 

class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  Gender _gender = Gender.MAN;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radio / RadioListTile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text('Gentleman'),
                leading: Radio(
                  value: Gender.MAN,
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value as Gender;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Lady'),
                leading: Radio(
                  value: Gender.WOMEN,
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value as Gender;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              RadioListTile(
                title: Text('Gentleman'),
                value: Gender.MAN,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value as Gender;
                  });
                },
              ),
              RadioListTile(
                title: Text('Lady'),
                value: Gender.WOMEN,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value as Gender;
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

