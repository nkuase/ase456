// ============================================
// 5. COLLECTION SPREADS & IF/FOR IN COLLECTIONS
// ============================================

void collectionSpreadsExample() {
  print('\n=== Collection Spreads & If/For Examples ===');

  var list1 = [1, 2];
  var list2 = [3, 4];
  bool condition = true;
  var range = [10, 20, 30];

  // Dart's powerful collection syntax
  var combined = [
    ...list1, // Spread list1: [1, 2]
    ...list2, // Spread list2: [3, 4]
    if (condition) 5, // Conditional element: 5 (if true)
    for (var i in range) i * 2, // Generated elements: [20, 40, 60]
  ];

  print('Combined list: $combined'); // [1,2,3,4,5,20,40,60]
}

void main() {
  print('=== COLLECTION SPREADS & IF/FOR IN COLLECTIONS ===\n');
  collectionSpreadsExample();
}
