import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

// Get the root element and create React root
const root = ReactDOM.createRoot(
  document.getElementById('root')
);

// Render the App component
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
