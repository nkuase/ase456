import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: AlertDialogPage());}
} 

class AlertDialogPage extends StatefulWidget {
  @override
  State<AlertDialogPage> createState() => _AlertDialogPageState();
}

class _AlertDialogPageState extends State<AlertDialogPage> {
  TextEditingController _controller = TextEditingController();
  String inputString = "";
  var _title = 'AlertDialogPage';
  
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
  
  _update(result) {
    setState(() {_title = result;});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var result = await _openDialog('hello');
              _update(result);
            },
            child: Text(_title),
          ),
          Text(_title),
        ],
      ),
    );
  }

  _openDialog(String info) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Title + ${info}'),
          content: TextFormField(controller: _controller),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



