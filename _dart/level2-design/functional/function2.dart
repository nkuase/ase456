typedef Compare<T> = int Function(T a, T b);
int sort(int a, int b) => a - b;

typedef Arith<T> = T Function(T a, T b);
Arith<int> sub = (int a, int b) {return (a - b);};

void functionPrint(Arith<int> f, int x, int y) {
  print(f(x, y));
}

void main() {
  print(sort is Compare<int>); // True!
  functionPrint(sub, 10, 20);
}

