// lib/viewmodels/counter_viewmodel.dart
import '../models/counter.dart';

class CounterViewModel {
  Counter _counter = Counter(0);
  
  // View can read this - ALWAYS returns current value
  int get count => _counter.value;
  
  // View calls this - UPDATES the internal state
  void increment() {
    _counter = _counter.increment();
  }
  
  // Method to check current state (for debugging if needed)
  void printCurrentState() {
    print('Current ViewModel state: ${_counter.value}');
  }
}