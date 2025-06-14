// ignore: depend_on_referenced_packages
import 'package:hive_flutter/hive_flutter.dart';

class Database {
  // Box<dynamic> shoppingBox;
  String db;
  late Box<dynamic> shoppingBox;
  Database({required this.db}) {
    shoppingBox = Hive.box(db);
  }

  List<Map<String, dynamic>> toList() {
    final data = shoppingBox.keys.map((key) {
      final value = shoppingBox.get(key);
      return {"key": key, "name": value["name"], "quantity": value['quantity']};
    }).toList();
    return data;
  }

  // Create new item
  Future<void> createItem(Map<String, dynamic> newItem) async {
    await shoppingBox.add(newItem);
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  Map<String, dynamic> readItem(int key) {
    final item = shoppingBox.get(key);
    return item;
  }

  // Update a single item
  Future<void> updateItem(int itemKey, Map<String, dynamic> item) async {
    await shoppingBox.put(itemKey, item);
  }

  // Delete a single item
  Future<void> deleteItem(int itemKey) async {
    await shoppingBox.delete(itemKey);
  }
}
