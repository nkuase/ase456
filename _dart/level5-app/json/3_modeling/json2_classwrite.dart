import 'dart:convert';
import 'dart:io';

class User {
  int id; String user; String password;
  User({required this.id, required this.user, required this.password});
}

Future writeJsonFile({required String filePath, required List<User> users}) async {
  // Create a map from a list of User objects
  var m = {};
  var l = [];
  users.forEach((val) {
    var m2 = {'id': val.id, 'user':'${val.user}', 'password':'${val.password}'};
    l.add(m2);
  });
  m['users'] = l;
  
  var js = json.encode(m);;
  return await File(filePath).writeAsString(js);
}

void main() async {
  var listUsers = [
    User(id:1, user:'user1', password:'p455w0rd'), 
    User(id:2, user:'user2', password:'p445w0rd')
  ];

  var r = await writeJsonFile(filePath:'./file.json', users:listUsers); 
  print(r); 
}
