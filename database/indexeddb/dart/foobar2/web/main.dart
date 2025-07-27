import 'package:web/web.dart';
import 'dart:js_interop';
import 'package:foobar/foo_crud.dart';

void showOutput(String msg) {
  final outputDiv = document.querySelector('#output');
  if (outputDiv != null) {
    final p = HTMLParagraphElement();
    p.textContent = msg;
    outputDiv.appendChild(p);
  }
}

void main() {
  final createBtn = document.querySelector('#create') as HTMLButtonElement?;
  final readBtn = document.querySelector('#read') as HTMLButtonElement?;
  final readAllBtn = document.querySelector('#readall') as HTMLButtonElement?;
  final updateBtn = document.querySelector('#update') as HTMLButtonElement?;
  final deleteBtn = document.querySelector('#delete') as HTMLButtonElement?;

  final inputKey = document.querySelector('#key') as HTMLInputElement?;
  final inputFoo = document.querySelector('#foo') as HTMLInputElement?;
  final inputBar = document.querySelector('#bar') as HTMLInputElement?;

  int? parseKey(String? value) => int.tryParse(value ?? '');

  // Event handlers with no parameters:
  void handleCreate() async {
    if (inputFoo == null || inputBar == null || inputKey == null) return;

    final data = {
      'foo': inputFoo.value,
      'bar': int.tryParse(inputBar.value) ?? 0,
    };
    final key = await create(data);
    inputKey.value = key.toString();
    showOutput('Created with key $key: $data');
  }

  void handleRead() async {
    if (inputKey == null) return;

    final key = parseKey(inputKey.value);
    if (key == null) {
      showOutput('Invalid key');
      return;
    }
    final result = await read(key);
    showOutput('Read from key $key: $result');
  }

  void handleReadAll() async {
    final result = await readAll();
    showOutput('Read all data: $result');
  }

  void handleUpdate() async {
    if (inputKey == null || inputFoo == null || inputBar == null) return;

    final key = parseKey(inputKey.value);
    if (key == null) {
      showOutput('Invalid key');
      return;
    }

    final data = {
      'foo': inputFoo.value,
      'bar': int.tryParse(inputBar.value) ?? 0,
    };
    await update(key, data);
    showOutput('Updated key $key with $data');
  }

  void handleDelete() async {
    if (inputKey == null) return;

    final key = parseKey(inputKey.value);
    if (key == null) {
      showOutput('Invalid key');
      return;
    }
    await deleteRecord(key);
    showOutput('Deleted key $key');
  }

  createBtn?.onclick = handleCreate.toJS;
  readBtn?.onclick = handleRead.toJS;
  readAllBtn?.onclick = handleReadAll.toJS;
  updateBtn?.onclick = handleUpdate.toJS;
  deleteBtn?.onclick = handleDelete.toJS;
}
