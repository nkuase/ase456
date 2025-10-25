import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  FlatList,
  StyleSheet,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';

/**
 * React Native Todo App
 * 
 * Key React Native concepts:
 * - FlatList for efficient list rendering (like Flutter's ListView.builder)
 * - TextInput for text input (like Flutter's TextField)
 * - KeyboardAvoidingView for keyboard handling
 * - Platform-specific styling
 * 
 * Flutter equivalent: StatefulWidget with ListView
 */
export default function TodoApp() {
  const [todos, setTodos] = useState([]);
  const [inputValue, setInputValue] = useState('');

  const addTodo = () => {
    if (inputValue.trim()) {
      const newTodo = {
        id: Date.now().toString(),
        text: inputValue,
        completed: false,
      };
      setTodos([...todos, newTodo]);
      setInputValue('');
    }
  };

  const toggleTodo = (id) => {
    setTodos(
      todos.map((todo) =>
        todo.id === id ? { ...todo, completed: !todo.completed } : todo
      )
    );
  };

  const deleteTodo = (id) => {
    setTodos(todos.filter((todo) => todo.id !== id));
  };

  const clearCompleted = () => {
    setTodos(todos.filter((todo) => !todo.completed));
  };

  // Calculate stats
  const totalTodos = todos.length;
  const completedTodos = todos.filter((t) => t.completed).length;
  const activeTodos = totalTodos - completedTodos;

  // Render individual todo item
  const renderTodoItem = ({ item }) => (
    <View style={styles.todoItem}>
      <TouchableOpacity
        onPress={() => toggleTodo(item.id)}
        style={styles.todoContent}
      >
        <View style={[styles.checkbox, item.completed && styles.checkboxChecked]}>
          {item.completed && <Text style={styles.checkmark}>✓</Text>}
        </View>
        <Text style={[styles.todoText, item.completed && styles.todoTextCompleted]}>
          {item.text}
        </Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={() => deleteTodo(item.id)} style={styles.deleteButton}>
        <Text style={styles.deleteButtonText}>✕</Text>
      </TouchableOpacity>
    </View>
  );

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <View style={styles.header}>
        <Text style={styles.title}>📝 Todo List</Text>
      </View>

      {/* Input section */}
      <View style={styles.inputContainer}>
        <TextInput
          style={styles.input}
          value={inputValue}
          onChangeText={setInputValue}
          placeholder="What needs to be done?"
          onSubmitEditing={addTodo}
          returnKeyType="done"
        />
        <TouchableOpacity style={styles.addButton} onPress={addTodo}>
          <Text style={styles.addButtonText}>Add</Text>
        </TouchableOpacity>
      </View>

      {/* Stats */}
      {totalTodos > 0 && (
        <View style={styles.stats}>
          <Text style={styles.statText}>Total: {totalTodos}</Text>
          <Text style={styles.statText}>Active: {activeTodos}</Text>
          <Text style={styles.statText}>Done: {completedTodos}</Text>
        </View>
      )}

      {/* Todo list using FlatList */}
      <FlatList
        data={todos}
        renderItem={renderTodoItem}
        keyExtractor={(item) => item.id}
        style={styles.list}
        contentContainerStyle={todos.length === 0 ? styles.emptyList : null}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Text style={styles.emptyText}>No todos yet. Add one above! ☝️</Text>
          </View>
        }
      />

      {/* Clear completed button */}
      {completedTodos > 0 && (
        <TouchableOpacity style={styles.clearButton} onPress={clearCompleted}>
          <Text style={styles.clearButtonText}>
            Clear Completed ({completedTodos})
          </Text>
        </TouchableOpacity>
      )}
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    paddingTop: 60,
    paddingBottom: 20,
    backgroundColor: '#4caf50',
    alignItems: 'center',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: 'white',
  },
  inputContainer: {
    flexDirection: 'row',
    padding: 15,
    backgroundColor: 'white',
    gap: 10,
  },
  input: {
    flex: 1,
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
  },
  addButton: {
    backgroundColor: '#4caf50',
    paddingHorizontal: 25,
    borderRadius: 8,
    justifyContent: 'center',
  },
  addButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
  stats: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    padding: 15,
    backgroundColor: 'white',
    marginTop: 2,
  },
  statText: {
    fontSize: 14,
    color: '#666',
  },
  list: {
    flex: 1,
  },
  emptyList: {
    flexGrow: 1,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 30,
  },
  emptyText: {
    fontSize: 16,
    color: '#999',
    textAlign: 'center',
    fontStyle: 'italic',
  },
  todoItem: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'white',
    padding: 15,
    marginTop: 2,
  },
  todoContent: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
  },
  checkbox: {
    width: 24,
    height: 24,
    borderWidth: 2,
    borderColor: '#4caf50',
    borderRadius: 4,
    marginRight: 15,
    justifyContent: 'center',
    alignItems: 'center',
  },
  checkboxChecked: {
    backgroundColor: '#4caf50',
  },
  checkmark: {
    color: 'white',
    fontSize: 16,
    fontWeight: 'bold',
  },
  todoText: {
    flex: 1,
    fontSize: 16,
    color: '#333',
  },
  todoTextCompleted: {
    textDecorationLine: 'line-through',
    color: '#999',
  },
  deleteButton: {
    padding: 5,
    paddingHorizontal: 10,
  },
  deleteButtonText: {
    fontSize: 20,
    color: '#f44336',
  },
  clearButton: {
    margin: 15,
    padding: 15,
    backgroundColor: '#ff9800',
    borderRadius: 8,
    alignItems: 'center',
  },
  clearButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
});
