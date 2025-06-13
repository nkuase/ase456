import 'dart:convert';

f1()
{
  var encoded = json.encode([1, 2, { "a": null }]);
  var decoded = json.decode('["foo", { "bar": 499 }]');
  print(encoded); print(encoded.runtimeType); 
  print(decoded); print(decoded.runtimeType);
}
f2()
{
  var encoded = jsonEncode([1, 2, { "a": null }]);
  var decoded = jsonDecode('["foo", { "bar": 499 }]');
  print(encoded); print(encoded.runtimeType); 
  print(decoded); print(decoded.runtimeType);
}
main() {
  f1();
  f2();
}

/*
[1,2,{"a":null}] -> String
[foo, {bar: 499}] -> List<dynamic>
*/