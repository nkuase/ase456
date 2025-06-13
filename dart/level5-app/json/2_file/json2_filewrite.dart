import 'dart:convert';
import 'dart:io';

// Let dart compiler guess the return type
// https://docs.flutter.dev/cookbook/persistence/reading-writing-files
Future writeJsonFile({required String filePath, required String data}) async {
  return await File(filePath).writeAsString(data);
}

void main() async {
  var list = {'users':[{'id': 1, 'user': 'user1', 'password': 'p455w0rd'}, {'id': 2, 'user': 'user2', 'pass': 'p455w0rd'}]};
  var js = json.encode(list);
  print(js);
  var r = await writeJsonFile(filePath:'./file2.json', data:js); 
  print(r); // File: './file2.json'
}