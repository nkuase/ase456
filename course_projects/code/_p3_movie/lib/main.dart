import 'package:flutter/material.dart';
import 'package:p3_movie/view/movie_list.dart';

void main() => runApp(MyMovies());

class MyMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MovieList(),
    );
  }
}
