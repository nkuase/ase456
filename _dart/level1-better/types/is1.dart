main() {
  int x = 10;
  print(x is int); // all true
  print(x is num);
  print(x is Object); 
  print(x is double); // false
  print(x as num); // 10 (int) -> 10 (num)
  print(x.runtimeType); // exact type checking: int
}