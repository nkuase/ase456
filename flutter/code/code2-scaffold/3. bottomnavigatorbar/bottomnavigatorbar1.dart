import 'package:flutter/material.dart';

// We can add Bottom Navigator Bar with the MaterialApp

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationPage(),
    );
  }
}

class BottomNavigationPage extends StatelessWidget {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BottomNavigationBar')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificatio',
          ),
        ],
      ),
    );
  }
}
