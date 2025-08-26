// ============================================
// 7. NULL SAFETY EXAMPLES
// ============================================

void nullSafetyExample() {
  print('\n=== Null Safety Examples ===');

  String name = 'Hi'; // Non-nullable
  String? nullableName; // Nullable, defaults to null

  print('Non-nullable name: $name');
  print('Nullable name: $nullableName');
}

void chainingExample() {
String? first = null;
String? second = null; 
String? third = "Found!";

String result = first ?? 
                second ?? 
                third ??
                'Default';

String result2 = first ?? 
                second ?? 
                'Default';                

  print('Chained name: $result-$result2');
} 

void nullCoalescingExample() {
  print('\n=== Null Coalescing Examples ===');
  String? nullableName; // Nullable, defaults to null

  // Null coalescing operator
  String displayName = nullableName ?? 'Anonymous';
  print('Display name: $displayName');
}

void nullAwareAssignmentExample() {
  print('\n=== Null Aware Assignment Example ===');
  String? nullableName; // Nullable, defaults to null
  // Null aware assignment
  nullableName ??= 'Default Name';
  print('After ??= assignment: $nullableName');
}

void main() {
  print('=== NULL SAFETY EXAMPLES ===\n');
  nullSafetyExample();
  chainingExample();
  nullCoalescingExample();
  nullAwareAssignmentExample();
}
