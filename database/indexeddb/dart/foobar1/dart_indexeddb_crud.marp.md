---
marp: true
theme: default
class: lead
paginate: true
---

<!-- _class: front-page -->

# 🐦 Dart + IndexedDB

Simple CRUD Tutorial with Dart in the Browser

---

## 🔧 What You'll Learn

- How to store JSON in IndexedDB
- Basic CRUD operations (Create, Read, Update, Delete)
- Dart + Web application setup

---

## 📦 JSON Format

```json
{
  "foo": "name",
  "bar": 43
}
```

This is the data format we will use.

---

## 🧱 Setup Files

- `pubspec.yaml` - project metadata
- `indexeddb_crud.dart` - Dart logic
- `main.dart.js` - compiled JavaScript
- `index.html` - web wrapper
- `run.sh` - build & run shell script

---

## 🧪 Dart CRUD Code

```dart
final key = await create({"foo": "name", "bar": 43});
final record = await read(key);
await update(key, {"foo": "updated", "bar": 99});
await deleteRecord(key);
```

---

## ▶️ Run Your App

1. Install Dart SDK
2. Make script executable: `chmod +x run.sh`
3. Run: `./run.sh`
4. Open browser: [http://localhost:8000](http://localhost:8000)

---

## ✅ Done!

- You now have a working IndexedDB CRUD app in Dart
- Open DevTools Console to view logs