import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, SafeAreaView } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import CounterApp from './components/CounterApp';
import TodoApp from './components/TodoApp';
import UserListApp from './components/UserListApp';

/**
 * Main App Component
 * Demonstrates component composition and navigation in React Native
 * 
 * Teaching Points:
 * - SafeAreaView for handling notches/status bars
 * - Tab-based navigation (simple implementation)
 * - Component composition
 * - Conditional rendering
 */
export default function App() {
  const [activeTab, setActiveTab] = useState('counter');

  const renderContent = () => {
    switch (activeTab) {
      case 'counter':
        return <CounterApp />;
      case 'todo':
        return <TodoApp />;
      case 'users':
        return <UserListApp />;
      default:
        return <CounterApp />;
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="light" />
      
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>React Native Examples</Text>
        <Text style={styles.headerSubtitle}>
          Demonstrating key React Native concepts
        </Text>
      </View>

      {/* Tab Navigation */}
      <View style={styles.tabContainer}>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'counter' && styles.activeTab]}
          onPress={() => setActiveTab('counter')}
        >
          <Text style={[styles.tabText, activeTab === 'counter' && styles.activeTabText]}>
            Counter
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.tab, activeTab === 'todo' && styles.activeTab]}
          onPress={() => setActiveTab('todo')}
        >
          <Text style={[styles.tabText, activeTab === 'todo' && styles.activeTabText]}>
            Todo
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.tab, activeTab === 'users' && styles.activeTab]}
          onPress={() => setActiveTab('users')}
        >
          <Text style={[styles.tabText, activeTab === 'users' && styles.activeTabText]}>
            Users
          </Text>
        </TouchableOpacity>
      </View>

      {/* Tab Content */}
      <View style={styles.content}>
        {renderContent()}
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#667eea',
  },
  header: {
    padding: 20,
    backgroundColor: '#667eea',
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
    textAlign: 'center',
  },
  headerSubtitle: {
    fontSize: 14,
    color: 'rgba(255, 255, 255, 0.8)',
    textAlign: 'center',
    marginTop: 5,
  },
  tabContainer: {
    flexDirection: 'row',
    backgroundColor: '#667eea',
    paddingHorizontal: 15,
    paddingBottom: 10,
  },
  tab: {
    flex: 1,
    paddingVertical: 12,
    marginHorizontal: 5,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    borderRadius: 8,
    alignItems: 'center',
  },
  activeTab: {
    backgroundColor: 'white',
  },
  tabText: {
    fontSize: 16,
    fontWeight: '600',
    color: 'white',
  },
  activeTabText: {
    color: '#667eea',
  },
  content: {
    flex: 1,
    backgroundColor: 'white',
  },
});
