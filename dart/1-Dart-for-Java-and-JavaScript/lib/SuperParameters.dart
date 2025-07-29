// Super Parameters - Flutter Widget Example
// Example from "Dart for Java and JavaScript programmers" lecture

// Simulating Flutter's Widget hierarchy
abstract class Widget {
  final String? key;

  const Widget({this.key});

  @override
  String toString() => '${runtimeType}(key: $key)';
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key}); // Super parameter!

  String build();
}

abstract class StatefulWidget extends Widget {
  const StatefulWidget({super.key}); // Super parameter!
}

// TRADITIONAL WAY (Verbose)
class MyAppTraditional extends StatelessWidget {
  // Declare + forward manually
  const MyAppTraditional({String? key}) : super(key: key);
  //                      │                    │       │
  //                      │                    │       └── Pass to parent
  //                      │                    └────────── Call parent constructor
  //                      └───────────────────────────────── Declare parameter
  @override
  String build() {
    return 'Hello, World! in MyAppTraditional'; // Example widget   
  }
}

// SUPER PARAMETERS (Concise)
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Super parameter!
  // No need to declare or forward the key parameter explicitly
  
  @override
  String build() {
    return 'Hello, World! in MyApp'; // Example widget
  } // Direct forwarding! Same functionality, cleaner syntax
}

void demonstrateSuperParameters() {
  print('=== Super Parameters Example ===');
  
  // Using traditional way
  MyAppTraditional appTraditional = MyAppTraditional(key: 'app1');
  print(appTraditional.build());

  // Using super parameters
  MyApp app = MyApp(key: 'app2');
  print(app.build());
} 

void main() {
  demonstrateSuperParameters();
}
