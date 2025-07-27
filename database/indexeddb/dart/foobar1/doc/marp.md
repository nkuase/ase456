---
marp: true
title: Dart Web, IndexedDB, and `package:web`: Why Use Import Prefixes and Hide?
---

# Dart + IndexedDB + package:web: Handling Import Conflicts

## Problem: Multiple Libraries, Same Names

- Modern Dart web apps use both:
  - `idb_shim` for IndexedDB (local database in browser)
  - `package:web` for HTML DOM events and elements

- These libraries **define types with the same names**, including:
  - `Request`
  - `Event`

## Dart Import Example

```
import 'package:idb_shim/idb.dart' as idb;
import 'package:idb_shim/idb_browser.dart';
import 'package:web/web.dart' hide Request, Event;
import 'dart:js_interop';
```

## Why Use `hide Request, Event`?

- If **two libraries both export a type named `Request` or `Event`**, Dart gets confused.
  - Example: Is `Event` a DOM event or a database event?
- You'll get a compile error:
  > "The name 'Event' is defined in the libraries..."

- Solution:
  - Use `as idb` to **prefix** all IndexedDB types: `idb.Request`, `idb.Database`, etc.
  - Use `hide Request, Event` on `package:web` to **avoid loading conflicting types** from that package.

## When to Use Each Type?

- Use `idb.Request`, `idb.Event` for IndexedDB API:
  - Used in database code and event listeners for upgrades, etc.
- Use `package:web`'s DOM types (except `Request`, `Event` which you hid):
  - For `HTMLButtonElement`, `HTMLInputElement`, etc.
  - Event handlers in JS interop don't need the `Event` parameter type, so it's safe to hide.

## Clean, Conflict-Free Code

- This import strategy makes your code:
  - **Clearer**: You always know which `Request` or `Event` you mean.
  - **Error-free**: Dart compiler doesn't face ambiguous types.
  - **Robust**: Adheres to Dart web best practices as of Dart 3.7+ and package:web.

## In Summary

> Hiding `Request` and `Event` from `package:web` is necessary to avoid naming conflicts with `idb_shim`.  
>  
> Prefixing `idb_shim` with `as idb` lets you refer to all IndexedDB types unambiguously, while still using DOM types from `package:web`.  
>  
> This makes Dart web and database code clean and maintainable.

## Reference: Typical Usage

```
import 'package:idb_shim/idb.dart' as idb;
import 'package:web/web.dart' hide Request, Event;

// IndexedDB usage
Future<idb.Database> openDb() async { ... }

// Web usage
final btn = document.querySelector('#myButton') as HTMLButtonElement?;
btn?.onclick = () { ... }.toJS;
```

---
```

