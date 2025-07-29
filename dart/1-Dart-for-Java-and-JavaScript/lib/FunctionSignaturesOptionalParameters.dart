// ============================================
// 3. FUNCTION SIGNATURES WITH OPTIONAL PARAMETERS
// ============================================

class RecordModel {
  final int id;
  final String data;

  RecordModel(this.id, this.data);

  @override
  String toString() => 'RecordModel(id: $id, data: $data)';
}

Future<RecordModel?> getRecord([int page = 1, int perPage = 5]) async {
  // Simulate async operation
  await Future.delayed(Duration(milliseconds: 100));

  if (page > 0 && perPage > 0) {
    return RecordModel(page, 'Data for page $page with $perPage items');
  }
  return null;
}

Future<void> functionSignatureExample() async {
  print('\n=== Function Signature Examples ===');

  // All these calls are valid:
  var result1 = await getRecord(); // page=1, perPage=5
  var result2 = await getRecord(2); // page=2, perPage=5
  var result3 = await getRecord(3, 10); // page=3, perPage=10

  print('getRecord(): $result1');
  print('getRecord(2): $result2');
  print('getRecord(3, 10): $result3');
}

void main() async {
  print('=== FUNCTION SIGNATURES WITH OPTIONAL PARAMETERS ===\n');
  await functionSignatureExample();
}
