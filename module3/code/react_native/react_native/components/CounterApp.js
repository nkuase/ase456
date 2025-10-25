import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';

/**
 * React Native Counter App
 * 
 * Key differences from React web:
 * - Use View instead of div
 * - Use Text for all text (required!)
 * - Use TouchableOpacity instead of button
 * - Styling via StyleSheet objects
 * 
 * Flutter equivalent: StatefulWidget with setState
 */
export default function CounterApp() {
  const [count, setCount] = useState(0);

  const increment = () => setCount(count + 1);
  const decrement = () => setCount(count - 1);
  const reset = () => setCount(0);

  // Determine count color based on value
  const getCountColor = () => {
    if (count > 0) return '#4caf50'; // Green
    if (count < 0) return '#f44336'; // Red
    return '#333'; // Default
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Counter App</Text>

      {/* Display count */}
      <View style={styles.countContainer}>
        <Text style={[styles.count, { color: getCountColor() }]}>
          {count}
        </Text>
      </View>

      {/* Button row */}
      <View style={styles.buttonRow}>
        <TouchableOpacity
          style={[styles.button, styles.decrementButton]}
          onPress={decrement}
        >
          <Text style={styles.buttonText}>-</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.button, styles.resetButton]}
          onPress={reset}
        >
          <Text style={styles.buttonText}>Reset</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.button, styles.incrementButton]}
          onPress={increment}
        >
          <Text style={styles.buttonText}>+</Text>
        </TouchableOpacity>
      </View>

      {/* Conditional messages */}
      {count > 10 && (
        <Text style={styles.message}>Count is getting high! 🔥</Text>
      )}
      {count < 0 && (
        <Text style={styles.message}>Count is negative! ❄️</Text>
      )}
    </View>
  );
}

/**
 * Styling in React Native
 * - Similar to CSS but uses JavaScript objects
 * - camelCase property names (backgroundColor not background-color)
 * - No units for numbers (just use numbers)
 * - Flexbox by default
 */
const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f5f5f5',
    padding: 20,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    marginBottom: 40,
    color: '#333',
  },
  countContainer: {
    marginBottom: 40,
  },
  count: {
    fontSize: 80,
    fontWeight: 'bold',
  },
  buttonRow: {
    flexDirection: 'row',
    gap: 15,
  },
  button: {
    paddingVertical: 15,
    paddingHorizontal: 25,
    borderRadius: 8,
    minWidth: 80,
    alignItems: 'center',
  },
  decrementButton: {
    backgroundColor: '#f44336',
  },
  resetButton: {
    backgroundColor: '#607d8b',
  },
  incrementButton: {
    backgroundColor: '#4caf50',
  },
  buttonText: {
    color: 'white',
    fontSize: 24,
    fontWeight: 'bold',
  },
  message: {
    marginTop: 30,
    fontSize: 18,
    fontWeight: '600',
    color: '#666',
  },
});
