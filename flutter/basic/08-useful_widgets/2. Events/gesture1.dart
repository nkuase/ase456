import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:GesturePage())); 

class GesturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GestureDetector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Use GestureDetector to add onTap method
            GestureDetector(
              onTap: () {
                print('GestureDetector Click!!');
              },
              child: Text('Click Me!!'),
            ),
            SizedBox(
              height: 40,
            ),
            // Use also InkWell to add onTap method
            InkWell(
              onTap: () {
                print('InkWell Click!!');
              },
              child: Text('Click Me!!'),
            ),
          ],
        ),
      ),
    );
  }
}
