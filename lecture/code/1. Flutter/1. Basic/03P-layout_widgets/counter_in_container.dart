import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'SingleChildScrollView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});
  final String title;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      
      // LESSON: SingleChildScrollView makes content scrollable
      // Without it, content would overflow and cause yellow/red stripe errors
      body: SingleChildScrollView(
        // Optional: Add padding around the scrollable content
        padding: EdgeInsets.all(16.0),
        
        // LESSON: Column widget arranges children vertically
        // When content exceeds screen height, SingleChildScrollView allows scrolling
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // Header section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Welcome to Flutter!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: 20), // Space between widgets
            
            // Counter display section
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'Counter Value:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$_counter',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Information cards section
            ...List.generate(5, (index) => Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Information Card ${index + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This is sample content to demonstrate how SingleChildScrollView works. '
                    'When you have more content than can fit on the screen, '
                    'SingleChildScrollView allows users to scroll through it.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )),
            
            // Bottom section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info,
                    size: 40,
                    color: Colors.purple,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Learning Tip',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try removing SingleChildScrollView from the code and see what happens! '
                    'You\'ll get overflow errors when content doesn\'t fit.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Button section (alternative to FloatingActionButton)
            ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Increment Counter'),
                ],
              ),
            ),
            
          ],
        ),
      ),
      
      // Keep the original FloatingActionButton as well
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}