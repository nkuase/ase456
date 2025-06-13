// final add = (int a, int b) => a + b; // single command
final add = (int a, int b) {return (a + b);}; // multiple commands
typedef Arith = int Function(int a, int b);
Arith sub = (int a, int b) {return (a - b);};

void functionPrint(Arith f, x, y) {
  print(f(x, y));
}

calculator(f, int first) {
  num sum(second) {
    return f(first, second);
  }
  return sum;
}

main() {
  print(calculator(add, 10)(20));
  print(((int a, int b) => a + b)(10,20));
  functionPrint((int a, int b) {return (a + b);}, 10, 20); 
  functionPrint(sub, 10, 20); 
}	