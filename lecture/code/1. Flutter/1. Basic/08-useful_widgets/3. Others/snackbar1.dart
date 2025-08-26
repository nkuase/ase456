import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:SnackBarPage())); 

class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title'),),
      body: TextButton(
        child: Text('Click to Process'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );
        }
      ),
    );
  }
}


