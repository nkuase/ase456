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
          onPressed: () async { // should wait for the response
            final result = await Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (c) {
                  return PageA(info:'Page A');
                }
              )
            );
            print(result); // Console
          }
        ),
      ),
    );
  }
}

class PageA extends StatelessWidget {
  String info;
  PageA({Key? key, required this.info}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page A')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Page A (argument ${info}) - Click the button to get the result'),
          IconButton(
            onPressed: () {
              Navigator.pop(context, 10); // returns 10 
            },
            icon: Icon(Icons.add)),
       ],
      )
    );
  }
}




