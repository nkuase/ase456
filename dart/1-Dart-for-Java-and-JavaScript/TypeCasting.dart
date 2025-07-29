// ============================================
// 8. TYPE CASTING EXAMPLES
// ============================================

void typeCastingExample() {
  print('\n=== Type Casting Examples ===');

  dynamic value = "hello";
  String text = value as String;
  print('Casted text: $text');

  // Nullable casting
  dynamic nullValue = null;
  String? nullableText = nullValue as String?;
  print('Nullable cast result: $nullableText');

  // With null coalescing
  String safeName = nullableText ?? 'default';
  print('Safe name: $safeName');
}

void main() {
  print('=== TYPE CASTING EXAMPLES ===\n');
  typeCastingExample();
}
