import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:DatePickerPage())); 

class DatePickerPage extends StatefulWidget {
  @override
  _DatePickerPageState createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  DateTime _selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DatePicker'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              var selectedDate = showDatePicker(
                context: context,
                initialDate: DateTime.now(), 
                firstDate: DateTime(2025), 
                lastDate: DateTime(2030), 
              ); // showDatePicker
              selectedDate.then((dateTime) {
                setState(() {
                  _selectedTime = dateTime as DateTime;
                });
              });
            },
            child: Text('Date Picker'),
          ),
          Text('$_selectedTime'),
        ],
      ),
    );
  }
}

