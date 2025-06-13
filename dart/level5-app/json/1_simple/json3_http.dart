import 'package:http/http.dart' as http;
import 'dart:convert';

// Make sure what json file is returned from
// https://jsonplaceholder.typicode.com/todos/1

void main() async {
  String url = 'https://jsonplaceholder.typicode.com/todos/1';
  var response = await http.get(Uri.parse(url));

  Map<String, dynamic> data = jsonDecode(response.body);
  print('userId : ${data['userId']}');
  print('id : ${data['id']}');
  print('title : ${data['title']}');
  print('complete : ${data['completed']}');
}

