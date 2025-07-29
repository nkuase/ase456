import 'dart:convert';
  
void main() {
  Map<String, dynamic> dartMap = {
    'data': {
      'data': { 'foo': 'value', 'bar': 123 }
    }
  };
  String jsonString = jsonEncode(dartMap);
  print(jsonString);

  dartMap = jsonDecode(jsonString);
  print(dartMap);
}
