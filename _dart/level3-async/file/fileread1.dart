import 'dart:io';

// Let dart compiler guess the return type
Future readFile(String filePath) async {
  var res = await File(filePath).readAsString();
  return res;
}

void main() async {
  var r = await readFile('./file.txt'); 
  r.split('\n').forEach((val) { // PC may use \n\r instead
    print('val: ${val}');
    final splitted = val.split(' ');
    print('${int.parse(splitted[0])}-${int.parse(splitted[1])}');
  });
}
