import 'package:flutter/material.dart';

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
        // load image from network
        child: Image.network('https://www.nku.edu/content/www/news/2022/July/InnovativeUniversityRankings2022/jcr:content/par/columncontrol_131879386/column-2/columncontrol/column-1/image.img.1280.medium.jpg/1986091456.jpg'),
      ),
    );
  }
}

