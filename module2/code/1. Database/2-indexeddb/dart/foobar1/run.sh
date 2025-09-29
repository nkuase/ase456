#!/bin/bash
set -e

#dart pub deps
dart pub get
# dart pub outdated
# dart pub upgrade --major-versions
dart compile js web/foobar.dart -o web/main.dart.js
echo "Serving at http://localhost:8000"
python3 -m http.server