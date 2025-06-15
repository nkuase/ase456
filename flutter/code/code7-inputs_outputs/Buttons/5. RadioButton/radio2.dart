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
  String _text = 'Gentleman was Chosen';
  @override
  Widget build(BuildContext context) {
    _update(value) {
       setState(() {
         _gender = value as Gender;
         if (_gender == Gender.MAN) {
           _text = 'Gentleman was Chosen';
         }
         else {
          _text = 'Lady was Chosen';
         }
       }
     );
    }                     
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
              RadioListTile(
                title: Text('Gentleman'),
                value: Gender.MAN,
                groupValue: _gender,
                onChanged: (value) {_update(value);},
              ),
              RadioListTile(
                title: Text('Lady'),
                value: Gender.WOMEN,
                groupValue: _gender,
                onChanged: (value) {_update(value);},
              ),
              SizedBox(
                height: 40,
              ),
              Text(this._text),
            ],
          ),
        ),
      ),
    );
  }
}

