import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: CircleAvatarPage());}
} 

class CircleAvatarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CircleAvatar'),
      ),
      body: Center(
        child: CircleAvatar(
          child: Icon(Icons.person),
        ),
      ),
    );
  }
}

/*
We need to use GestureDetector when we want add actions to the CircleAvatar

GestureDetector(
  onTap: () {
   //do what you want here
  },
  child:  CircleAvatar(
     radius: 55.0,
      backgroundImage: ExactAssetImage('assets/cat.jpg'),
  ), 
),
*/        
