import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home:MyApp())); 

class MyApp extends StatefulWidget {
  const MyApp(); 
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends  State<MyApp> {
  int tab = 0; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [Home1(), Home2()][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: tab,
        onTap: (i) {
          setState(() {tab = i;});
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home1',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Home2',
              backgroundColor: Colors.red),
        ],
      ),
    );
  }
} 

class Home1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Home1",
        style: TextStyle(
          fontSize: 48, // Make text big; adjust as needed
          fontWeight: FontWeight.bold, // Optional: make it bold
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Home2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body:Text("Home2"),
    );
  }
}