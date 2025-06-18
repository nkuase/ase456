import 'package:flutter/material.dart';

/*
return DefaultTabController(
  length: 3,
  child: Scaffold(
    appBar: AppBar(
      title: ...
      bottom: const TabBar(
        tabs: <Widget>[
          Tab(...),
          Tab(...),
          Tab(...),
        ]
      )
    )
    body: TabBarView(
      children: <Widget>[
        ...             
      ],
    ),
  ),
),  
*/

// We can use tabs in the Material App Design

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TabPage(),);
  }
}

class TabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. DefaultTabController is needed
    return DefaultTabController(
      // 2. Specify the number of tabs
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tab'),
          // 3. Specify tabBar with three tabs
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.tag_faces)),
              Tab(text: 'Menu2'),
              Tab(icon: Icon(Icons.info), text: 'Menu3'),
            ],
          ),
        ),
        // Specify tabbarview
        // We use Container as a Page, but we can use other widgets/pages
        body: TabBarView(
          children: <Widget>[
            Container(color: Colors.yellow,),
            Container(color: Colors.orange,),
            Container(color: Colors.red,),
          ]
        ),
      ),
    );
  }
}

