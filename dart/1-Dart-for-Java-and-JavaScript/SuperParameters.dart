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

  Widget build();
}

abstract class StatefulWidget extends Widget {
  const StatefulWidget({super.key}); // Super parameter!

  State createState();
}

abstract class State<T extends StatefulWidget> {
  Widget build();
}

// Example implementations

// TRADITIONAL WAY (Verbose)
class MyAppTraditional extends StatelessWidget {
  // Declare + forward manually
  const MyAppTraditional({String? key}) : super(key: key);
  //                      │                    │       │
  //                      │                    │       └── Pass to parent
  //                      │                    └────────── Call parent constructor
  //                      └───────────────────────────────── Declare parameter

  @override
  Widget build() {
    return MaterialApp(title: 'Flutter Demo Traditional');
  }
}

// SUPER PARAMETERS (Concise)
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  }); // Direct forwarding! Same functionality, cleaner syntax

  @override
  Widget build() {
    return MaterialApp(title: 'Flutter Demo');
  }
}

// More complex example with multiple parameters
class CustomButton extends StatelessWidget {
  final String text;
  final String color;
  final Function onPressed;

  // Traditional way would be:
  // const CustomButton({String? key, required this.text, required this.color, required this.onPressed})
  //     : super(key: key);

  // With super parameters:
  const CustomButton({
    super.key, // Forwarded to parent
    required this.text, // Own parameter
    required this.color, // Own parameter
    required this.onPressed, // Own parameter
  });

  @override
  Widget build() {
    return ButtonWidget(text: text, color: color, onPressed: onPressed);
  }
}

// Stateful widget example
class CounterWidget extends StatefulWidget {
  final int initialValue;
  final String title;

  const CounterWidget({
    super.key, // Forwarded to StatefulWidget
    this.initialValue = 0, // Own parameter with default
    required this.title, // Required own parameter
  });

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int counter;

  @override
  Widget build(dynamic widget) {
    counter = widget.initialValue;
    return CounterDisplay(title: widget.title, value: counter);
  }
}

// Multiple inheritance levels
abstract class AnimatedWidget extends StatefulWidget {
  final Duration duration;

  const AnimatedWidget({
    super.key, // Forward to StatefulWidget
    required this.duration, // Own parameter
  });
}

class FadeWidget extends AnimatedWidget {
  final Widget child;
  final double opacity;

  const FadeWidget({
    super.key, // Forward to AnimatedWidget (and then to StatefulWidget)
    super.duration, // Forward to AnimatedWidget
    required this.child, // Own parameter
    this.opacity = 1.0, // Own parameter with default
  });

  @override
  State<FadeWidget> createState() => _FadeWidgetState();
}

class _FadeWidgetState extends State<FadeWidget> {
  @override
  Widget build() {
    return OpacityWidget(
      duration: widget.duration,
      opacity: widget.opacity,
      child: widget.child,
    );
  }
}

// Simulated Flutter widgets for demonstration
class MaterialApp extends Widget {
  final String title;
  const MaterialApp({super.key, required this.title});

  @override
  String toString() => 'MaterialApp(title: $title, ${super.toString()})';
}

class ButtonWidget extends Widget {
  final String text;
  final String color;
  final Function onPressed;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  String toString() =>
      'ButtonWidget(text: $text, color: $color, ${super.toString()})';
}

class CounterDisplay extends Widget {
  final String title;
  final int value;

  const CounterDisplay({super.key, required this.title, required this.value});

  @override
  String toString() =>
      'CounterDisplay(title: $title, value: $value, ${super.toString()})';
}

class OpacityWidget extends Widget {
  final Duration duration;
  final double opacity;
  final Widget child;

  const OpacityWidget({
    super.key,
    required this.duration,
    required this.opacity,
    required this.child,
  });

  @override
  String toString() =>
      'OpacityWidget(duration: $duration, opacity: $opacity, ${super.toString()})';
}

// Demonstration functions
void demonstrateSuperParameters() {
  print('=== SUPER PARAMETERS DEMONSTRATION ===\n');

  print('--- Creating widgets without keys ---');
  var app1 = MyApp();
  var app2 = MyAppTraditional();
  print('MyApp: ${app1.build()}');
  print('MyAppTraditional: ${app2.build()}');

  print('\n--- Creating widgets with keys ---');
  var app3 = MyApp(key: 'main-app');
  var app4 = MyAppTraditional(key: 'traditional-app');
  print('MyApp with key: ${app3.build()}');
  print('MyAppTraditional with key: ${app4.build()}');
}

void demonstrateComplexSuperParameters() {
  print('\n=== COMPLEX SUPER PARAMETERS ===\n');

  print('--- Custom Button Examples ---');
  var button1 = CustomButton(
    text: 'Click Me',
    color: 'blue',
    onPressed: () => print('Button clicked!'),
  );

  var button2 = CustomButton(
    key: 'submit-button',
    text: 'Submit',
    color: 'green',
    onPressed: () => print('Form submitted!'),
  );

  print('Button without key: ${button1.build()}');
  print('Button with key: ${button2.build()}');

  print('\n--- Counter Widget Examples ---');
  var counter1 = CounterWidget(title: 'Simple Counter');
  var counter2 = CounterWidget(
    key: 'main-counter',
    title: 'Advanced Counter',
    initialValue: 10,
  );

  print('Counter without key: ${counter1.createState().build()}');
  print('Counter with key: ${counter2.createState().build()}');
}

void demonstrateMultipleLevels() {
  print('\n=== MULTIPLE INHERITANCE LEVELS ===\n');

  var textWidget = ButtonWidget(
    key: 'text-widget',
    text: 'Sample Text',
    color: 'black',
    onPressed: () {},
  );

  var fadeWidget = FadeWidget(
    key: 'fade-widget',
    duration: Duration(seconds: 2),
    opacity: 0.5,
    child: textWidget,
  );

  print('Fade widget: ${fadeWidget.createState().build()}');
}

void demonstrateParameterForwarding() {
  print('\n=== PARAMETER FORWARDING EXPLANATION ===\n');

  print('Super parameter syntax breakdown:');
  print('MyApp({super.key})');
  print('│     │    │   │');
  print('│     │    │   └── Parameter name');
  print('│     │    └────── Super parameter syntax');
  print('│     └─────────── Named parameters');
  print('└───────────────── Constructor name');
  print('');
  print('Translation: "Accept an optional `key` parameter and');
  print('forward it directly to the parent StatelessWidget constructor"');

  print('\nComparison:');
  print('Traditional: MyApp({String? key}) : super(key: key);');
  print('Super param: MyApp({super.key});');
  print('             ↑ Same functionality, less code!');
}

void main() {
  demonstrateSuperParameters();
  demonstrateComplexSuperParameters();
  demonstrateMultipleLevels();
  demonstrateParameterForwarding();
}
