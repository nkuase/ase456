import 'package:web/web.dart' as web;
import '../lib/foobar_crud.dart';

void showOutput(String msg) {
  final div = web.document.querySelector('#output') as web.HTMLDivElement?;
  if (div != null) {
    div.innerHTML += '<p>${msg}</p>';
  }
}

void showError(String error) {
  final div = web.document.querySelector('#output') as web.HTMLDivElement?;
  if (div != null) {
    div.innerHTML += '<p style="color: red;">Error: ${error}</p>';
  }
}

void main() {
  // Get DOM elements with null checking
  final createBtn =
      web.document.querySelector('#create') as web.HTMLButtonElement?;
  final readBtn = web.document.querySelector('#read') as web.HTMLButtonElement?;
  final updateBtn =
      web.document.querySelector('#update') as web.HTMLButtonElement?;
  final deleteBtn =
      web.document.querySelector('#delete') as web.HTMLButtonElement?;

  final inputKey = web.document.querySelector('#key') as web.HTMLInputElement?;
  final inputFoo = web.document.querySelector('#foo') as web.HTMLInputElement?;
  final inputBar = web.document.querySelector('#bar') as web.HTMLInputElement?;

  // Check if all elements exist
  if (createBtn == null ||
      readBtn == null ||
      updateBtn == null ||
      deleteBtn == null ||
      inputKey == null ||
      inputFoo == null ||
      inputBar == null) {
    print('Error: One or more required HTML elements not found');
    return;
  }

  // Create button handler
  createBtn.onclick = (web.Event event) {
    handleCreate(inputFoo, inputBar, inputKey);
  };

  // Read button handler
  readBtn.onclick = (web.Event event) {
    handleRead(inputKey);
  };

  // Update button handler
  updateBtn.onclick = (web.Event event) {
    handleUpdate(inputKey, inputFoo, inputBar);
  };

  // Delete button handler
  deleteBtn.onclick = (web.Event event) {
    handleDelete(inputKey);
  };
}

// Separate async functions for each CRUD operation
Future<void> handleCreate(web.HTMLInputElement inputFoo,
    web.HTMLInputElement inputBar, web.HTMLInputElement inputKey) async {
  try {
    final data = {
      'foo': inputFoo.value ?? '',
      'bar': int.tryParse(inputBar.value ?? '') ?? 0,
    };
    final key = await create(data);
    inputKey.value = key.toString();
    showOutput('Created with key $key: $data');
  } catch (e) {
    showError('Failed to create record: $e');
  }
}

Future<void> handleRead(web.HTMLInputElement inputKey) async {
  try {
    final key = int.tryParse(inputKey.value ?? '');
    if (key == null) {
      showError('Invalid key - please enter a valid number');
      return;
    }
    final result = await read(key);
    showOutput('Read from key $key: $result');
  } catch (e) {
    showError('Failed to read record: $e');
  }
}

Future<void> handleUpdate(web.HTMLInputElement inputKey,
    web.HTMLInputElement inputFoo, web.HTMLInputElement inputBar) async {
  try {
    final key = int.tryParse(inputKey.value ?? '');
    if (key == null) {
      showError('Invalid key - please enter a valid number');
      return;
    }
    final data = {
      'foo': inputFoo.value ?? '',
      'bar': int.tryParse(inputBar.value ?? '') ?? 0,
    };
    await update(key, data);
    showOutput('Updated key $key with $data');
  } catch (e) {
    showError('Failed to update record: $e');
  }
}

Future<void> handleDelete(web.HTMLInputElement inputKey) async {
  try {
    final key = int.tryParse(inputKey.value ?? '');
    if (key == null) {
      showError('Invalid key - please enter a valid number');
      return;
    }
    await deleteRecord(key);
    showOutput('Deleted key $key');
  } catch (e) {
    showError('Failed to delete record: $e');
  }
}
