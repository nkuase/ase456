import 'package:flutter/material.dart';

/*
Navigator.push(context, MaterialPageRoute(builder: (c) { return ...;}));
Navigator.pop(context);
*/
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Navigator Demo')), 
      body: Center(
        child: TextButton(
          child: Text('Click to Show Other Page'),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (c) {
                  return PageA();
                }
              )
            );
          }
        ),
      ),
    );
  }
}

class PageA extends StatelessWidget {
  const PageA({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page A')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Page A'),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close)),
       ],
      )
    );
  }
}


