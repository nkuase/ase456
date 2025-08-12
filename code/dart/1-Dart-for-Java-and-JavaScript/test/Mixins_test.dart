import 'package:test/test.dart';
import '../lib/Mixins.dart'; // Adjust path as necessary

void main() {
  test('Fish can breathe underwater', () {
    final fish = Fish();
    expect(() => fish.breatheUnderwater(), prints("Breathing through gills!\n"));
  });
}  