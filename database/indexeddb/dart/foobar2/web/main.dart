import 'foo_crud.dart';

void main() async {
  var db = await openDb();

  // CREATE
  int key = await addItem(db, {"foo": "Alice", "bar": 42});
  showOutput('Item added with key: $key');

  // READ
  var items = await getAllItems(db);
  showOutput('All items: $items');

  // UPDATE
  await updateItem(db, key, {"foo": "Alice Updated", "bar": 99});
  showOutput('Item updated.');

  // DELETE
  await deleteItem(db, key);
  showOutput('Item deleted.');
}
