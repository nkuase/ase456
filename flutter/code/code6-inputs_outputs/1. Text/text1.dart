import 'package:flutter/material.dart';

// You need to make a Flutter Project for this project
// 1. Make a flutter project - flutter create project
// 2. In the created project change pubspec.yaml 
//    https://docs.flutter.dev/development/ui/assets-and-images
// 3. Use the asset image

void main() => runApp(MyApp()); 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return MaterialApp(home: ImagePage());}
} 

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Center(
        // load image from asset
        // You CAN'T use dartpad.dev for this example
        child: const Text('Image'), 
      ),
    );
  }
}

