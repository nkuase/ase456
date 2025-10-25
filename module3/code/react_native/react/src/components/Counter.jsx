import React, { useState } from 'react';
import './Counter.css';

/**
 * Simple Counter Component
 * Demonstrates: useState hook, event handling, state updates
 * 
 * Flutter equivalent: StatefulWidget with setState
 */
function Counter() {
  // State declaration - similar to Flutter's state variable
  const [count, setCount] = useState(0);

  // Event handlers
  const increment = () => setCount(count + 1);
  const decrement = () => setCount(count - 1);
  const reset = () => setCount(0);

  return (
    <div className="counter-container">
      <h1>Counter App</h1>
      
      {/* Display current count */}
      <div className="count-display">
        {count}
      </div>

      {/* Control buttons */}
      <div className="button-group">
        <button onClick={decrement} className="btn btn-danger">
          -
        </button>
        <button onClick={reset} className="btn btn-secondary">
          Reset
        </button>
        <button onClick={increment} className="btn btn-success">
          +
        </button>
      </div>

      {/* Conditional rendering */}
      {count > 10 && (
        <p className="message">Count is getting high! 🔥</p>
      )}
      {count < 0 && (
        <p className="message">Count is negative! ❄️</p>
      )}
    </div>
  );
}

export default Counter;
