import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:DialogPage())); 

class DialogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlertDialogPage'),
      ),
      body: ElevatedButton(
        // click the button to display dialog
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
              return const Dialog(
                child: Text('Dialog Title'),
              );
            }
          );
        },
        child: const Text('Alert Dialog'),
      ),
    );
  }
}

