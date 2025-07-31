import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: ProgressPage());}
} 

class ProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // cirular type indicator
            CircularProgressIndicator(),
            SizedBox(
              height: 40,
            ),
            // linear type indicator
            LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
