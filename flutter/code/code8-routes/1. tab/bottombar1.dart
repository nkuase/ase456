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
  static const TextStyle optionStyle =
    TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Text("Home1", style: optionStyle,)
      ),
    );
  }
}

class Home2 extends StatelessWidget {
  static const TextStyle optionStyle =
    TextStyle(fontSize: 40, fontWeight: FontWeight.w100);  
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Text("Home2", style: optionStyle,)
      ),
    );
  }
}