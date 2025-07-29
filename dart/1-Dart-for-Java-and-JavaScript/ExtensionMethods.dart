// ============================================
// 4. EXTENSION METHODS
// ============================================

extension StringExtension on String {
  String reverse() => split('').reversed.join('');
  bool get isEmail => contains('@') && contains('.');
}

void extensionMethodExample() {
  print('\n=== Extension Method Examples ===');
  print('"hello".reverse(): ${"hello".reverse()}'); // "olleh"
  print('"test@email.com".isEmail: ${"test@email.com".isEmail}'); // true
  print('"invalid".isEmail: ${"invalid".isEmail}'); // false
}

void main() {
  print('=== EXTENSION METHODS ===\n');
  extensionMethodExample();
}
