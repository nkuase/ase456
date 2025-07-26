import 'package:idb_shim/idb_browser.dart';

void main() async {
  final idbFactory = getIdbFactory()!;
  // Open the database, creating/upgrading it if needed
  final db = await idbFactory.open('my_simple_db', version: 1,
      onUpgradeNeeded: (VersionChangeEvent e) {
    final db = e.database;
    db.createObjectStore('store', autoIncrement: true);
    print('Object store created');
  });

  // Add a value
  final txn = db.transaction('store', 'readwrite');
  final store = txn.objectStore('store');
  await store.add({'name': 'Alice', 'age': 30});
  await txn.completed;

  // Read all values
  final txn2 = db.transaction('store', 'readonly');
  final store2 = txn2.objectStore('store');
  final values = await store2.getAll();
  print('All values: $values');
  await txn2.completed;
}
