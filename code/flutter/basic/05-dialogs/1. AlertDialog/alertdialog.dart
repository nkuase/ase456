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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlertDialogPage'),
      ),
      body: ElevatedButton(
        // click the button to display dialog
        onPressed: () {
          _openDialog();
        },
        child: const Text('Alert Dialog'),
      ),
    );
  }

  _openDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Alert Dialog'),
                Text('Click OK to end'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              // we can add more buttons 
            ),
          ],
        );
      },
    );
  }
}


