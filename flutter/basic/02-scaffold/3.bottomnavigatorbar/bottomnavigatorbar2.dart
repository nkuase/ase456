import 'package:flutter/material.dart';

// We can add Bottom Navigator Bar with the MaterialApp

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyStateful(),);
  }
}

class MyStateful extends StatefulWidget {
  @override
  State<MyStateful> createState() => BottomNavigationPage();
}  


class BottomNavigationPage extends State<MyStateful> {
  int index = 0;
  
  void updateIndex(int index) {
    setState(() {this.index = index;}); // Notify Dart UI to update screen
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar'),
      ),
      body: Center(
        child: Text('$index',
          style: TextStyle(fontSize: 48),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (index) {updateIndex(index);},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificatio',
          ),
        ],
      ),
    );
  }
}


