import React, { useState, useEffect } from 'react';
import './UserList.css';

/**
 * User List Component
 * 
 * Demonstrates:
 * - useEffect for data fetching
 * - Loading states
 * - API calls
 * - Mapping over arrays
 * 
 * Flutter equivalent: ListView.builder with FutureBuilder
 */
function UserList() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Fetch users from API
  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const response = await fetch('https://jsonplaceholder.typicode.com/users');
        const data = await response.json();
        setUsers(data);
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch users');
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);

  if (loading) {
    return (
      <div className="user-list-container">
        <div className="loading">
          <div className="spinner"></div>
          <p>Loading users...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="user-list-container">
        <div className="error">{error}</div>
      </div>
    );
  }

  return (
    <div className="user-list-container">
      <h1>👥 User List</h1>
      <p className="subtitle">{users.length} users found</p>

      <div className="user-grid">
        {users.map((user, index) => (
          <div key={user.id} className="user-card">
            <div className="user-avatar">
              <img 
                src={`https://i.pravatar.cc/150?img=${index + 1}`} 
                alt={user.name}
              />
            </div>
            <div className="user-info">
              <h3>{user.name}</h3>
              <p className="user-email">{user.email}</p>
              <p className="user-company">{user.company.name}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default UserList;
