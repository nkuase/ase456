var s1 = 'Single quotes';
var s2 = "Double quotes";
var s3 = 'Double quotes in "single" quotes';
var s4 = "Single quotes in 'double' quotes";

var m1 = '''A
multiline
string''';

var m2 = """
Another
multiline
string""";

main() {
  print(m2);
  const string = 'Dart is fun';
  
  print(string.substring(0, 4)); // 'Dart'
  const string = 'Dart ' + 'is ' + 'fun!';
  print(string); // 'Dart is fun!'
  const string = 'Dart ' 'is ' 'fun!';
  print(string); // 'Dart is fun!'
  const string = 'Dart';
  final charAtIndex = string[0];
  print(charAtIndex); // 'D'  
}