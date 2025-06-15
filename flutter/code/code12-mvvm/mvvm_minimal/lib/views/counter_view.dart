// lib/views/counter_view.dart
import 'package:flutter/material.dart';
import '../viewmodels/counter_viewmodel.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterViewModel viewModel = CounterViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini MVVM Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display count from ViewModel
            Text(
              'Count: ${viewModel.count}',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            
            // Increment button
            ElevatedButton(
              onPressed: () {
                viewModel.increment();  // Update ViewModel
                setState(() {});        // Trigger UI rebuild
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Add 1'),
            ),
            
            const SizedBox(height: 20),
            
            // Test button to show state persists
            ElevatedButton(
              onPressed: () {
                viewModel.printCurrentState(); // Only this print for debugging
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Print State (No UI Update)'),
            ),
            
            const SizedBox(height: 40),
            
            // MVVM Explanation
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How it works:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('1. viewModel.increment() updates internal state', style: TextStyle(fontSize: 12)),
                  const Text('2. setState() triggers widget rebuild', style: TextStyle(fontSize: 12)),
                  const Text('3. build() runs again', style: TextStyle(fontSize: 12)),
                  const Text('4. viewModel.count returns NEW value', style: TextStyle(fontSize: 12)),
                  const Text('5. UI shows updated count', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(
                    'Pure MVVM: Clean separation of concerns!',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.orange.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}