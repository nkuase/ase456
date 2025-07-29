// ============================================
// 7. NULL SAFETY EXAMPLES
// ============================================

void nullSafetyExample() {
  print('\n=== Null Safety Examples ===');

  String name = 'Hi'; // Non-nullable
  String? nullableName; // Nullable, defaults to null

  print('Non-nullable name: $name');
  print('Nullable name: $nullableName');

  // Null coalescing operator
  String displayName = nullableName ?? 'Anonymous';
  print('Display name: $displayName');

  // Null aware assignment
  nullableName ??= 'Default Name';
  print('After ??= assignment: $nullableName');
}

void main() {
  print('=== NULL SAFETY EXAMPLES ===\n');
  nullSafetyExample();
}
