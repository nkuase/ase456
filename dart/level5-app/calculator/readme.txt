## Find what package to use
* Google to find the package: in this example, we find that we need expression package.
* From pub.dev, we find expression 0.2.5 `https://pub.dev/packages/expressions`
* We add the information in the pubspec.yaml under the dependencies. 

## Process
dart create calculator
cd calculator

copy all the files in the lib/bin/test into the calculator directories accordingly
copy pubspec.yaml to replace calculator/pubspec.yaml

dart pub upgrade
dart pub get
dart run
dart test