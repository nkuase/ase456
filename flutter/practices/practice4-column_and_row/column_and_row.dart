// When we need to draw a box shape, we can use container
import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: LayoutComparisonExample());}
} 

class LayoutComparisonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Layout Widget Comparison')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Column Example
            Text('Column - Vertical Sequential Layout', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 100, height: 40, color: Colors.red, child: Center(child: Text('Item 1'))),
                  Container(width: 100, height: 40, color: Colors.green, child: Center(child: Text('Item 2'))),
                  Container(width: 100, height: 40, color: Colors.blue, child: Center(child: Text('Item 3'))),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Row Example
            Text('Row - Horizontal Sequential Layout', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 60, height: 60, color: Colors.red, child: Center(child: Text('A'))),
                  Container(width: 60, height: 60, color: Colors.green, child: Center(child: Text('B'))),
                  Container(width: 60, height: 60, color: Colors.blue, child: Center(child: Text('C'))),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Container Example
            Text('Container - Single Child Wrapper', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              width: 200,
              height: 100,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                border: Border.all(color: Colors.purple, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text('Only One Child\nAllowed', textAlign: TextAlign.center),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Stack Example
            Text('Stack - Overlapping Layout', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 150,
              width: 200,
              child: Stack(
                children: [
                  // Bottom layer
                  Container(
                    width: 120,
                    height: 120,
                    color: Colors.red[300],
                    child: Center(child: Text('Bottom')),
                  ),
                  // Middle layer
                  Positioned(
                    top: 30,
                    left: 30,
                    child: Container(
                      width: 120,
                      height: 120,
                      color: Colors.green[300],
                      child: Center(child: Text('Middle')),
                    ),
                  ),
                  // Top layer
                  Positioned(
                    top: 60,
                    left: 60,
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.blue[300],
                      child: Center(child: Text('Top')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}