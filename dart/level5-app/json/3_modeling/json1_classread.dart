import 'dart:convert';
import 'dart:io';

// Model 
class User {
  int id; String user; String password;
  User({required this.id, required this.user, required this.password});
}

// Returning Future is OK as the compiler will guess the type
Future<List<User>> readJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  var map = json.decode(input);
  // List<User> result = <User>[];  
  var result = <User>[];
  
  map['users'].forEach((val) {
    var u = User(id:val['id'], user:val['user'], password:val['password']);
    result.add(u);
  });
  return result;
}

void main() async {
  /*
  [User(id: 1, user: user1, password: p455w0rd), User(id: 2, user: user2, pass: p455w0rd)]
  */
  var r = await readJsonFile('./file.json'); 

  // result is a list of User object
  r.forEach((val) {
    print('${val.id} ${val.user} ${val.password}');
  });
}