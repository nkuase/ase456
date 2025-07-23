import 'dart:convert';

const String header = '''
{"errorMessage":
  {
    "status":200,
    "code":"INFO-000",
    "message":"OK",
    "link":"",
    "developerMessage":"",
    "total":4
  }
}  
''';

void main() {
  var parsed = jsonDecode(header);
  var errorMessage = parsed['errorMessage'];
  // Map<String, dynamic> errorMessage = parsed['errorMessage'];
  print('status : ${errorMessage['status']}');
  print('code : ${errorMessage['code']}');
  print('message : ${errorMessage['message']}');
  print('total : ${errorMessage['total']}');
}