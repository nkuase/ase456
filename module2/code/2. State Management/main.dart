import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class CounterModel extends ChangeNotifier {
  // Private variable to hold the state
  int _count = 0;
  
  // Public getter to access the state
  // This ensures the state is read-only from outside
  int get count => _count;
  
  // Method to increment the counter
  void increment() {
    _count++;
    // This is the key! Notify all listeners that the state has changed
    notifyListeners();
  }
  
  // Method to decrement the counter
  void decrement() {
    _count--;
    // Always call notifyListeners() when state changes
    notifyListeners();
  }
  
  // Method to reset the counter
  void reset() {
    _count = 0;
    notifyListeners();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management with ChangeNotifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        // Create the CounterModel instance
        create: (context) => CounterModel(),
        child: const CounterScreen(),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ChangeNotifier Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Counter Value:',
              style: TextStyle(fontSize: 20),
            ),
            // Consumer rebuilds only when the model changes
            Consumer<CounterModel>(
              builder: (context, counterModel, child) {
                return Text(
                  '${counterModel.count}',
                  style: const TextStyle(
                    fontSize: 48, 
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Decrement button
                ElevatedButton(
                  onPressed: () {
                    // Access the model and call decrement
                    context.read<CounterModel>().decrement();
                  },
                  child: const Icon(Icons.remove),
                ),
                // Reset button
                ElevatedButton(
                  onPressed: () {
                    // Access the model and call reset
                    context.read<CounterModel>().reset();
                  },
                  child: const Icon(Icons.refresh),
                ),
                // Increment button
                ElevatedButton(
                  onPressed: () {
                    // Access the model and call increment
                    context.read<CounterModel>().increment();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
