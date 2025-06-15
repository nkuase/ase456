// When we need to draw a box shape, we can use container
import 'package:flutter/material.dart';

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: ContainerVsStackExample());}
} 

class ContainerVsStackExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Container vs Stack')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container Example: Profile Card
            Text('Container Example - Profile Card', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(  // Single child (Row)
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Text('J', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('John Doe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Software Developer', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            
            // Stack Example: Notification Badge
            Text('Stack Example - Notification Badge', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Stack(
              children: [  // Multiple children
                // Base icon
                Icon(
                  Icons.notifications,
                  size: 50,
                  color: Colors.grey,
                ),
                // Notification badge (overlapping on top)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 32),
            
            // Stack Example: Text over Image
            Text('Stack Example - Text over Image', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Stack(
              children: [
                // Background image
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Gradient overlay
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Text (on top)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    'Beautiful Landscape',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}