import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'SingleChildScrollView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});
  final String title;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      
      // LESSON: SingleChildScrollView makes content scrollable
      // Try removing this widget and see what happens!
      body: SingleChildScrollView(
        
        // LESSON: We put a single child widget here
        // In this case, it's a Center widget with lots of text
        child: Center(
          child: Text(
            // LESSON: This is a very long text that will definitely 
            // exceed the screen height and need scrolling
            '''
Welcome to Flutter!

Counter Value: $_counter

LEARNING ABOUT SINGLECHILDSCROLLVIEW:

What is SingleChildScrollView?
SingleChildScrollView is a widget that makes its content scrollable when the content is larger than the available space on the screen.

Why do we need it?
Without SingleChildScrollView, if your content is too tall for the screen, Flutter will show yellow and red overflow errors. These errors appear as yellow and black striped warning bars.

When to use SingleChildScrollView:
1. When you have long text (like this example)
2. When you have many widgets that don't fit on one screen
3. When you want users to scroll through content
4. When building forms that might be tall on small devices

How does it work?
SingleChildScrollView takes ONE child widget and makes it scrollable. If the child is taller than the screen, users can scroll up and down to see all the content.

EXPERIMENT TIME:
Try this experiment to understand better:

1. Remove the SingleChildScrollView widget from this code
2. Keep only: body: Center(child: Text(...))
3. Run the app and see the overflow errors
4. Add SingleChildScrollView back and see how it fixes the problem

EXAMPLE WITHOUT SINGLECHILDSCROLLVIEW:
body: Center(
  child: Text('This long text...')
)
❌ This will cause overflow errors!

EXAMPLE WITH SINGLECHILDSCROLLVIEW:
body: SingleChildScrollView(
  child: Center(
    child: Text('This long text...')
  )
)
✅ This works perfectly and allows scrolling!

Real-world examples where you'll use SingleChildScrollView:
- Reading long articles in news apps
- Scrolling through settings in apps
- Viewing long lists of information
- Reading terms and conditions
- Looking at product descriptions
- Browsing through chat messages

Remember: SingleChildScrollView can only have ONE direct child. If you need multiple widgets, you'll learn about Column and ListView widgets later!

Keep experimenting and happy coding!

Current counter value: $_counter
Tap the + button to increment!

More practice text to make this even longer...

The more you practice with Flutter widgets, the better you'll understand how they work together to create amazing mobile applications.

SingleChildScrollView is one of the most commonly used widgets in Flutter development because most real apps have content that needs scrolling.

This text is intentionally very long to demonstrate the scrolling behavior clearly. In a real app, you might have multiple widgets arranged in a Column instead of one long text widget.

End of demonstration text.
            ''',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ),
    );
  }
}