import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // key is used for identification, so ignore it for now
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage(title: 'Flutter Demo Home Page'),);
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    // Scaffold has three elements abf
    return Scaffold(
      appBar: AppBar(title: const Text(''),),
      body: const Text('Drawer'),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Item 1"),
              onTap: () {},
            ), 
            ListTile(
              leading: const Icon(Icons.train),
              title: const Text("Item 2"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}


