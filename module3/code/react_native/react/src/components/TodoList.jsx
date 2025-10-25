import React, { useState } from 'react';
import './TodoList.css';

/**
 * Todo List Component
 * Demonstrates: useState, lists, event handling, conditional rendering
 * 
 * Key concepts:
 * - Managing array state
 * - Adding/removing items
 * - Mapping over arrays (like Flutter's ListView.builder)
 * - Unique keys for list items
 */
function TodoList() {
  const [todos, setTodos] = useState([]);
  const [inputValue, setInputValue] = useState('');

  // Add new todo
  const addTodo = () => {
    if (inputValue.trim()) {
      const newTodo = {
        id: Date.now(), // Simple unique ID
        text: inputValue,
        completed: false
      };
      setTodos([...todos, newTodo]);
      setInputValue(''); // Clear input
    }
  };

  // Handle Enter key
  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      addTodo();
    }
  };

  // Toggle todo completion
  const toggleTodo = (id) => {
    setTodos(todos.map(todo =>
      todo.id === id
        ? { ...todo, completed: !todo.completed }
        : todo
    ));
  };

  // Delete todo
  const deleteTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };

  // Clear completed todos
  const clearCompleted = () => {
    setTodos(todos.filter(todo => !todo.completed));
  };

  // Stats
  const totalTodos = todos.length;
  const completedTodos = todos.filter(t => t.completed).length;
  const activeTodos = totalTodos - completedTodos;

  return (
    <div className="todo-container">
      <h1>📝 Todo List</h1>

      {/* Input section */}
      <div className="input-section">
        <input
          type="text"
          value={inputValue}
          onChange={(e) => setInputValue(e.target.value)}
          onKeyPress={handleKeyPress}
          placeholder="What needs to be done?"
          className="todo-input"
        />
        <button onClick={addTodo} className="add-btn">
          Add
        </button>
      </div>

      {/* Stats */}
      {totalTodos > 0 && (
        <div className="stats">
          <span>Total: {totalTodos}</span>
          <span>Active: {activeTodos}</span>
          <span>Completed: {completedTodos}</span>
        </div>
      )}

      {/* Todo list - Similar to Flutter's ListView */}
      <ul className="todo-list">
        {todos.map(todo => (
          <li key={todo.id} className={todo.completed ? 'completed' : ''}>
            <input
              type="checkbox"
              checked={todo.completed}
              onChange={() => toggleTodo(todo.id)}
            />
            <span className="todo-text">{todo.text}</span>
            <button
              onClick={() => deleteTodo(todo.id)}
              className="delete-btn"
            >
              ✕
            </button>
          </li>
        ))}
      </ul>

      {/* Empty state */}
      {todos.length === 0 && (
        <p className="empty-message">No todos yet. Add one above! ☝️</p>
      )}

      {/* Clear completed button */}
      {completedTodos > 0 && (
        <button onClick={clearCompleted} className="clear-btn">
          Clear Completed ({completedTodos})
        </button>
      )}
    </div>
  );
}

export default TodoList;
