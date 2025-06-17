// How to give arguments \to the route

import 'package:flutter/material.dart';

class Arguments {
  final String message;
  final int value;

  Arguments(this.message, this.value);
}

void main() {
  runApp(
    MaterialApp(
      title: 'Navigation with Arguments',
      home: const MyPage(),
      debugShowCheckedModeBanner: false,

      onGenerateRoute: (settings) {
        final args = settings.arguments as Arguments;
        if (settings.name == Page1.route) {
          return MaterialPageRoute(
            builder: (context) {
              return Page1(
                arguments: args,
              );
            },
          );
        }
        else {
          return MaterialPageRoute(
            builder: (context) {
              return Page2(
                arguments: args,
              );
            },
          );
        }
        return null;
      },
    )
  );
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              var res = await Navigator.pushNamed(
                context,
                Page1.route,
                arguments: Arguments('calling page1', 10),
              );
              print(res);
            },
            child: Text('Page1'),
          ),
          TextButton(
            onPressed: () async {
              var res = await Navigator.pushNamed(
                context,
                Page2.route,
                arguments: Arguments('calling page2', 20),
              );
              print(res);
            },
            child: Text('Page2'),
          ),
        ],                   
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  static String route = '/page1';
  Arguments arguments;

  Page1({required this.arguments,});
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Page1 ${arguments.message} ${arguments.value}"), // + ${this.message} ${this.value}"),
          IconButton(
            onPressed: () {
              Navigator.pop(context, arguments.value);
            },
            icon: const Icon(Icons.close)
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  static String route = '/page2';
   
  Arguments arguments;
  Page2({required this.arguments,});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Page2 ${arguments.message} ${arguments.value}'), 
          IconButton(
            onPressed: () {
              Navigator.pop(context, arguments.value);
            },
            icon: const Icon(Icons.close)
          ),
        ],
      ),
    );
  }
}