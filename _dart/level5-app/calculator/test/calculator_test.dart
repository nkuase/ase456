import 'package:calculator/lib.dart';
import 'package:test/test.dart';

void main() {
  test('eval', () {
    expect(eval('1+2+3'), 6);
    expect(eval('10*2+3'), 10 * 2 + 3);
  });
}
