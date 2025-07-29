// Flutter Lambda Examples
// Examples from "Lambda Expressions in Dart" lecture
// Note: This simulates Flutter widgets for educational purposes

void main() {
  print('=== FLUTTER LAMBDA EXAMPLES ===\n');
  
  demonstrateSetStateExamples();
  demonstrateEventHandlerExamples();
  demonstrateWidgetCreationExamples();
  demonstrateNavigationExamples();
}

// Simulated Flutter classes for demonstration
class Widget {
  final String description;
  Widget(this.description);
  
  @override
  String toString() => description;
}

class StatefulWidget extends Widget {
  StatefulWidget(String description) : super(description);
}

class ElevatedButton extends Widget {
  final void Function()? onPressed;
  final Widget child;
  
  ElevatedButton({required this.onPressed, required this.child}) 
      : super('ElevatedButton(child: \$child)');
}

class Text extends Widget {
  final String text;
  Text(this.text) : super('Text("\$text")');
}

class BottomNavigationBar extends Widget {
  final void Function(int)? onTap;
  
  BottomNavigationBar({required this.onTap}) 
      : super('BottomNavigationBar');
}

class ListTile extends Widget {
  final Widget? title;
  final void Function()? onTap;
  
  ListTile({this.title, this.onTap}) 
      : super('ListTile(title: \$title)');
}

// Simulated State management
class AppState {
  int counter = 0;
  int currentIndex = 0;
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];
  
  void setState(void Function() callback) {
    print('setState called...');
    callback();
    print('State updated - counter: \$counter, currentIndex: \$currentIndex');
  }
}

// ============================================
// 1. SETSTATE EXAMPLES
// ============================================

void demonstrateSetStateExamples() {
  print('--- setState() Lambda Examples ---');
  
  var appState = AppState();
  
  // Example from lecture: Lambda stored in variable
  print('Example 1: Lambda stored in variable');
  var updateFunction = () {
    appState.counter++;
  };
  appState.setState(updateFunction);
  
  // Example from lecture: Direct lambda (more common)
  print('\nExample 2: Direct lambda (recommended)');
  appState.setState(() {
    appState.counter++;
    print('Counter incremented in lambda');
  });
  
  // More complex setState examples
  print('\nExample 3: Complex state updates');
  appState.setState(() {
    appState.counter += 5;
    appState.currentIndex = 1;
    appState.items.add('New Item');
    print('Multiple state changes in one setState');
  });
  
  // Conditional setState
  print('\nExample 4: Conditional state updates');
  appState.setState(() {
    if (appState.counter > 10) {
      appState.counter = 0;
      print('Counter reset to 0');
    } else {
      appState.counter += 2;
      print('Counter incremented by 2');
    }
  });
  
  // setState with async operations simulation
  print('\nExample 5: setState with simulated async operations');
  void simulateAsyncOperation() {
    print('Starting async operation...');
    // Simulate async work
    Future.delayed(Duration(milliseconds: 100), () {
      appState.setState(() {
        appState.counter += 10;
        print('Async operation completed, counter updated');
      });
    });
  }
  simulateAsyncOperation();
}

// ============================================
// 2. EVENT HANDLER EXAMPLES
// ============================================

void demonstrateEventHandlerExamples() {
  print('\n--- Event Handler Lambda Examples ---');
  
  var appState = AppState();
  
  // Button click handlers
  print('Example 1: Button click handlers');
  
  var incrementButton = ElevatedButton(
    onPressed: () {
      print('Increment button clicked!');
      appState.setState(() => appState.counter++);
    },
    child: Text('Increment'),
  );
  
  var decrementButton = ElevatedButton(
    onPressed: () {
      print('Decrement button clicked!');
      appState.setState(() => appState.counter--);
    },
    child: Text('Decrement'),
  );
  
  var resetButton = ElevatedButton(
    onPressed: () {
      print('Reset button clicked!');
      appState.setState(() {
        appState.counter = 0;
        appState.currentIndex = 0;
      });
    },
    child: Text('Reset'),
  );
  
  // Simulate button presses
  incrementButton.onPressed!();
  decrementButton.onPressed!();
  resetButton.onPressed!();
  
  // Bottom Navigation example from lecture
  print('\nExample 2: Bottom Navigation (from lecture)');
  
  var bottomNav = BottomNavigationBar(
    onTap: (index) {
      print('Navigation tab \$index tapped');
      appState.setState(() {
        appState.currentIndex = index;
      });
    },
  );
  
  // Simulate navigation taps
  bottomNav.onTap!(0);
  bottomNav.onTap!(1);
  bottomNav.onTap!(2);
  
  // List item tap handlers
  print('\nExample 3: List item tap handlers');
  
  var listItems = appState.items.map((item) => ListTile(
    title: Text(item),
    onTap: () {
      print('Tapped on: \$item');
      appState.setState(() {
        appState.items.remove(item);
        print('\$item removed from list');
      });
    },
  )).toList();
  
  // Simulate tapping list items
  listItems[0].onTap!();
  listItems[1].onTap!();
}

// ============================================
// 3. WIDGET CREATION EXAMPLES
// ============================================

void demonstrateWidgetCreationExamples() {
  print('\n--- Widget Creation with Lambdas ---');
  
  // Creating widgets with lambda-generated content
  print('Example 1: Dynamic widget creation');
  
  var fruits = ['Apple', 'Banana', 'Orange', 'Grape'];
  
  // Using map to create widgets (common Flutter pattern)
  var fruitWidgets = fruits.map((fruit) => ListTile(
    title: Text(fruit),
    onTap: () => print('Selected: \$fruit'),
  )).toList();
  
  print('Created \${fruitWidgets.length} fruit widgets:');
  fruitWidgets.forEach((widget) => print('  \$widget'));
  
  // Creating buttons with different actions
  print('\nExample 2: Button generation with different actions');
  
  var buttonConfigs = [
    {'title': 'Save', 'action': () => print('Data saved!')},
    {'title': 'Load', 'action': () => print('Data loaded!')},
    {'title': 'Delete', 'action': () => print('Data deleted!')},
    {'title': 'Share', 'action': () => print('Data shared!')},
  ];
  
  var actionButtons = buttonConfigs.map((config) => ElevatedButton(
    onPressed: config['action'] as void Function()?,
    child: Text(config['title'] as String),
  )).toList();
  
  print('Created action buttons:');
  actionButtons.forEach((button) {
    print('  \$button');
    button.onPressed!(); // Simulate press
  });
  
  // Conditional widget creation
  print('\nExample 3: Conditional widget creation');
  
  bool isLoggedIn = true;
  bool isDarkMode = false;
  
  var conditionalWidgets = [
    if (isLoggedIn) Text('Welcome back!'),
    if (!isLoggedIn) Text('Please log in'),
    if (isDarkMode) Text('Dark mode enabled'),
    if (!isDarkMode) Text('Light mode enabled'),
  ];
  
  print('Conditional widgets:');
  conditionalWidgets.forEach((widget) => print('  \$widget'));
}

// ============================================
// 4. NAVIGATION AND COMPLEX EXAMPLES
// ============================================

void demonstrateNavigationExamples() {
  print('\n--- Navigation and Complex Lambda Examples ---');
  
  // Simulated navigation functions
  void navigateToPage(String pageName) {
    print('Navigating to: \$pageName');
  }
  
  void showDialog(String message) {
    print('Showing dialog: \$message');
  }
  
  void showSnackBar(String message) {
    print('Showing snackbar: \$message');
  }
  
  // Navigation examples
  print('Example 1: Navigation with lambdas');
  
  var navigationButtons = [
    ElevatedButton(
      onPressed: () => navigateToPage('Home'),
      child: Text('Home'),
    ),
    ElevatedButton(
      onPressed: () => navigateToPage('Profile'),
      child: Text('Profile'),
    ),
    ElevatedButton(
      onPressed: () => navigateToPage('Settings'),
      child: Text('Settings'),
    ),
  ];
  
  navigationButtons.forEach((button) {
    print('  \$button');
    button.onPressed!();
  });
  
  // Complex interaction examples
  print('\nExample 2: Complex interactions');
  
  var interactionButtons = [
    ElevatedButton(
      onPressed: () {
        showDialog('Are you sure you want to delete this item?');
        // Simulate confirmation
        print('Item deleted after confirmation');
      },
      child: Text('Delete with Confirmation'),
    ),
    ElevatedButton(
      onPressed: () {
        try {
          // Simulate some operation that might fail
          if (DateTime.now().millisecond % 2 == 0) {
            throw Exception('Random error occurred');
          }
          showSnackBar('Operation completed successfully');
        } catch (e) {
          showSnackBar('Error: \$e');
        }
      },
      child: Text('Operation with Error Handling'),
    ),
    ElevatedButton(
      onPressed: () {
        var count = 0;
        // Simulate multiple rapid operations
        for (int i = 0; i < 3; i++) {
          count++;
          print('Operation \$count completed');
        }
        showSnackBar('All operations completed: \$count');
      },
      child: Text('Multiple Operations'),
    ),
  ];
  
  print('Complex interaction examples:');
  interactionButtons.forEach((button) {
    print('  \$button');
    button.onPressed!();
  });
  
  // Form validation example
  print('\nExample 3: Form validation with lambdas');
  
  var validators = {
    'email': (String value) => value.contains('@') ? null : 'Invalid email',
    'password': (String value) => value.length >= 6 ? null : 'Password too short',
    'name': (String value) => value.isNotEmpty ? null : 'Name required',
  };
  
  var testData = {
    'email': 'user@example.com',
    'password': '123456',
    'name': 'John Doe',
  };
  
  testData.forEach((field, value) {
    var validator = validators[field]!;
    var error = validator(value);
    if (error == null) {
      print('\$field: "\$value" ✓ Valid');
    } else {
      print('\$field: "\$value" ✗ \$error');
    }
  });
}
