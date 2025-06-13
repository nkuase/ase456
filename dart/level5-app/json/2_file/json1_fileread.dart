import 'dart:convert';
import 'dart:io';

// Let dart compiler guess the return type
Future readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  var map = json.decode(input);
  return map;
}

void main() async {
  var r = await readJsonFile('./file.json'); 
  /*
  {id: 1, user: user1, password: p455w0rd}
  {id: 2, user: user2, pass: p455w0rd}
  */
  r["users"].forEach((val) {
    print(val);
  });
}