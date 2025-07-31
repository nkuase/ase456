import 'package:flutter/material.dart';
import 'showform.dart';

class CardWidget extends StatelessWidget {
  Map<String, dynamic> currentItem;
  Function _deleteItem;
  ShowForm show;

  CardWidget(this.currentItem, this.show, this._deleteItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade100,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
        title: Text(currentItem['name']),
        subtitle: Text(currentItem['quantity'].toString()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit button
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async =>
                    show.showForm(context, currentItem['key'])),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteItem(currentItem['key']),
            ),
          ],
        ),
      ),
    );
  }
}
