import React, { useState } from 'react';
import Counter from './components/Counter';
import TodoList from './components/TodoList';
import UserList from './components/UserList';
import './App.css';

/**
 * Main App Component
 * Demonstrates component composition and simple tab navigation
 * 
 * Teaching Points:
 * - Component composition
 * - State management for navigation
 * - Conditional rendering
 * - Props passing
 */
function App() {
  const [activeTab, setActiveTab] = useState('counter');

  const renderContent = () => {
    switch (activeTab) {
      case 'counter':
        return <Counter />;
      case 'todo':
        return <TodoList />;
      case 'users':
        return <UserList />;
      default:
        return <Counter />;
    }
  };

  return (
    <div className="app-container">
      {/* Header */}
      <div className="app-header">
        <h1>React Web Examples</h1>
        <p>Demonstrating key React concepts</p>
      </div>

      {/* Tab Navigation */}
      <div className="tab-container">
        <button
          className={`tab ${activeTab === 'counter' ? 'active' : ''}`}
          onClick={() => setActiveTab('counter')}
        >
          Counter
        </button>
        <button
          className={`tab ${activeTab === 'todo' ? 'active' : ''}`}
          onClick={() => setActiveTab('todo')}
        >
          Todo List
        </button>
        <button
          className={`tab ${activeTab === 'users' ? 'active' : ''}`}
          onClick={() => setActiveTab('users')}
        >
          Users
        </button>
      </div>

      {/* Tab Content */}
      <div className="tab-content">
        {renderContent()}
      </div>
    </div>
  );
}

export default App;
