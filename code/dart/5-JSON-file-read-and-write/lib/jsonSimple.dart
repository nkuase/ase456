import 'dart:convert';
import 'dart:io';
import 'asyncreadwrite.dart';

Future<bool> jsonWrite(String jsonPath, Map<String, dynamic> dartMap) async {
  String jsonString = jsonEncode(dartMap);
  try {
    bool success = await saveConfigAsync(jsonPath, jsonString);
    if (success) {
      print('JSON written successfully to $jsonPath');
      return true;
    } else {
      print('Failed to write JSON to $jsonPath');
      return false;
    }
  } catch (e) {
    print('Error writing JSON: $e');
    // rethrow the error to handle it in the main function
    // rethrow
    return false;
  }
}

Future<Map<String, dynamic>?> jsonRead(String jsonPath) async {
  try {
    String result = await loadConfigAsync(jsonPath) ?? '';
    Map<String, dynamic> dartMap = jsonDecode(result);
    return dartMap;
  } catch (e) {
    print('Error reading JSON: $e');
    return null;
  }
}

void main() async {
  final scriptPath = Platform.script.toFilePath();
  final scriptDir = File(scriptPath).parent.path;
  final jsonPath = '$scriptDir${Platform.pathSeparator}test.json';

  Map<String, dynamic> dartMap = {
    'name': 'John Doe',
    'age': 30,
    'isStudent': false,
    'courses': ['Math', 'Science', 'History'],
    'address': {'street': '123 Main St', 'city': 'Anytown', 'country': 'USA'},
  };
  bool success = await jsonWrite(jsonPath, dartMap);
  if (success) {
    print('JSON written successfully.');
  } else {
    print('Failed to write JSON.');
  }

  Map<String, dynamic>? readMap = await jsonRead(jsonPath);
  if (readMap != null) {
    print('JSON read successfully: $readMap');
  } else {
    print('Failed to read JSON or JSON is empty.');
  }
}
