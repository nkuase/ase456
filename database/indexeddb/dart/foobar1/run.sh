#!/bin/bash
set -e

dart pub get
dart compile js indexeddb_interactive.dart -o main.dart.js
echo "Serving at http://localhost:8000"
python3 -m http.server