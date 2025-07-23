import 'dart:io';

// Let dart compiler guess the return type
// https://docs.flutter.dev/cookbook/persistence/reading-writing-files
Future writeFile({required String filePath, required String data}) async {
  return await File(filePath).writeAsString(data);
}

void main() async {
  var list = ['line1', 'line2', 'line3'];
  // Use StringBuffer() to make mutable string
  var buffer = StringBuffer();
  list.forEach( (val) {
    buffer.write('${val}\n');
  });
  // buffer.toString() creates a string from a StingBuffer
  var r = await writeFile(filePath:'./file2.txt', data:buffer.toString()); 
  print(r); 
}