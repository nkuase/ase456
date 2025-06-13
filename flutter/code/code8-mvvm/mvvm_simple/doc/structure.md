# MVVM Architecture Structure

## Overview
This application follows the MVVM (Model-View-ViewModel) architectural pattern, which is particularly well-suited for Flutter applications. The MVVM pattern promotes better separation of concerns, testability, and maintainability.

## Project Structure
```
lib/
├── main.dart
├── models/
│   └── user.dart
├── viewmodels/
│   └── profile_viewmodel.dart
└── views/
    └── profile_view/
        ├── profile_view.dart
        ├── widgets/
        │   ├── status_card.dart
        │   ├── loading_indicator.dart
        │   ├── user_profile_card.dart
        │   ├── action_buttons_section.dart
        │   └── mvvm_explanation.dart
```

## Components and Their Relationships

### 1. Models
- Located in `lib/models/`
- Represents the data layer of the application
- Contains pure data objects without any business logic
- Example: `User` class that holds user-related data

### 2. ViewModels
- Located in `lib/viewmodels/`
- Acts as a bridge between Views and Models
- Contains business logic and state management
- Exposes methods and properties to Views
- Handles data transformations and business rules
- Example: `ProfileViewModel` manages user profile data and actions

### 3. Views
- Located in `lib/views/`
- Contains UI components and widgets
- Only knows about ViewModels, not Models
- Reacts to ViewModel changes through data binding
- Example: `ProfileView` displays user profile information

## Data Flow
1. **Initialization**:
   - View creates ViewModel instance
   - ViewModel initializes with default state

2. **User Interaction**:
   - User interacts with View
   - View calls ViewModel methods
   - ViewModel processes the request
   - ViewModel updates its state
   - View reacts to ViewModel state changes

3. **Data Changes**:
   - ViewModel updates its internal state
   - ViewModel notifies View of changes
   - View updates UI based on ViewModel state

## Key Principles

### Separation of Concerns
- Views handle UI logic and presentation
- ViewModels handle business logic and state
- Models handle data structures and persistence

### Unidirectional Data Flow
- Data flows from View → ViewModel → Model
- Changes flow back from Model → ViewModel → View

### State Management
- ViewModel maintains application state
- Views react to ViewModel state changes
- Business logic is encapsulated in ViewModels

## Implementation Details

### View (ProfileView)
- Uses StatefulWidget for state management
- Creates ViewModel instance in initState()
- Cleans up ViewModel in dispose()
- Uses widgets to compose UI
- Reacts to ViewModel state changes

### ViewModel (ProfileViewModel)
- Manages application state
- Handles user actions
- Coordinates with Models
- Exposes properties to Views
- Implements proper lifecycle management

### Model (User)
- Pure data class
- Holds business data
- No UI or business logic
- Used by ViewModels for data operations

## Best Practices

1. **ViewModel**
   - Keep business logic in ViewModels
   - Use streams for state management
   - Implement proper disposal
   - Expose only necessary properties

2. **View**
   - Keep Views dumb
   - Use widgets for composition
   - React to ViewModel state
   - Avoid direct Model access

3. **Model**
   - Keep Models pure
   - Use immutable data structures
   - Implement proper serialization
   - Keep business logic out of Models

This structure ensures a clean separation of concerns, making the application more maintainable, testable, and scalable.