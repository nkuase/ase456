extension Ext on String {
  int size() => this.length;
}

extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}

void main()
{
  print("hello".size()); // returns 5
  print("23".parseInt()); // 23
}