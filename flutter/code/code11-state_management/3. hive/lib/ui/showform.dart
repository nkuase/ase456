import 'package:flutter/material.dart';
import '../util/dbhelper.dart';

class ShowForm extends StatelessWidget {
  void Function() refreshItems;
  Database db;
  late List<Map<String, dynamic>> items;

  ShowForm({required this.db, required this.refreshItems});

// TextFields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void updateItems(List<Map<String, dynamic>> items) {
    this.items = items;
  }

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
          items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
    }

    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Quantity'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                // Save new item
                if (itemKey == null) {
                  db.createItem(
                    {
                      "name": _nameController.text,
                      "quantity": _quantityController.text
                    },
                  );
                } else {
                  db.updateItem(
                    itemKey,
                    {
                      'name': _nameController.text.trim(),
                      'quantity': _quantityController.text.trim()
                    },
                  );
                }
                refreshItems();

                // Clear the text fields
                _nameController.text = '';
                _quantityController.text = '';

                Navigator.of(ctx).pop(); // Close the bottom sheet
              },
              child: Text(itemKey == null ? 'Create New' : 'Update'),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
