
// =============================================================================
// UI INTERACTION FUNCTIONS (Event Handlers)
// =============================================================================

/// Set up event listeners for all buttons
void setupEventListeners() {
  try {
    // Add Student button
    final addBtn = web.document.getElementById('add-student-btn');
    if (addBtn != null) {
      addBtn.addEventListener('click', ((web.Event event) => handleAddStudent()).toJS);
    }

    // Get All Students button
    final getAllBtn = web.document.getElementById('get-all-students-btn');
    if (getAllBtn != null) {
      getAllBtn.addEventListener('click', ((web.Event event) => handleGetAllStudents()).toJS);
    }

    // Get Student button
    final getBtn = web.document.getElementById('get-student-btn');
    if (getBtn != null) {
      getBtn.addEventListener('click', ((web.Event event) => handleGetStudent()).toJS);
    }

    // Update Student button
    final updateBtn = web.document.getElementById('update-student-btn');
    if (updateBtn != null) {
      updateBtn.addEventListener('click', ((web.Event event) => handleUpdateStudent()).toJS);
    }

    // Delete Student button
    final deleteBtn = web.document.getElementById('delete-student-btn');
    if (deleteBtn != null) {
      deleteBtn.addEventListener('click', ((web.Event event) => handleDeleteStudent()).toJS);
    }

    // Clear All Students button
    final clearBtn = web.document.getElementById('clear-all-btn');
    if (clearBtn != null) {
      clearBtn.addEventListener('click', ((web.Event event) => handleClearAllStudents()).toJS);
    }
    
    log('🔗 Event listeners setup complete');
    
  } catch (error) {
    log('❌ Failed to setup event listeners: $error');
  }
}

/// Handle add student button click
void handleAddStudent() async {
  try {
    final idInput = web.document.getElementById('student-id') as web.HTMLInputElement?;
    final nameInput = web.document.getElementById('student-name') as web.HTMLInputElement?;
    final ageInput = web.document.getElementById('student-age') as web.HTMLInputElement?;
    final majorInput = web.document.getElementById('student-major') as web.HTMLInputElement?;

    if (idInput == null || nameInput == null || ageInput == null || majorInput == null) {
      log('❌ Could not find input elements');
      return;
    }

    // Validate inputs
    if (idInput.value.isEmpty ||
        nameInput.value.isEmpty ||
        ageInput.value.isEmpty ||
        majorInput.value.isEmpty) {
      log('⚠️ Please fill in all fields');
      return;
    }

    final age = int.tryParse(ageInput.value);
    if (age == null || age <= 0) {
      log('⚠️ Please enter a valid age');
      return;
    }

    final student = Student(
      id: idInput.value,
      name: nameInput.value,
      age: age,
      major: majorInput.value,
    );

    await createStudent(student);

    // Clear form
    idInput.value = '';
    nameInput.value = '';
    ageInput.value = '';
    majorInput.value = '';
    
  } catch (error) {
    log('❌ Error adding student: $error');
  }
}

/// Handle get all students button click
void handleGetAllStudents() async {
  try {
    log('📋 Retrieving all students...');
    final students = await readAllStudents();

    if (students.isEmpty) {
      log('📭 No students found in database');
    } else {
      log('👥 All Students:');
      for (final student in students) {
        log('  • ${student.toString()}');
      }
    }
  } catch (error) {
    log('❌ Error getting all students: $error');
  }
}

/// Handle get student button click
void handleGetStudent() async {
  try {
    final searchInput = web.document.getElementById('search-id') as web.HTMLInputElement?;
    
    if (searchInput == null) {
      log('❌ Could not find search input element');
      return;
    }

    if (searchInput.value.isEmpty) {
      log('⚠️ Please enter a student ID to search');
      return;
    }

    final student = await readStudent(searchInput.value);
    if (student != null) {
      log('🔍 Found: ${student.toString()}');
    }

    searchInput.value = '';
    
  } catch (error) {
    log('❌ Error getting student: $error');
  }
}

/// Handle update student button click
void handleUpdateStudent() async {
  try {
    final idInput = web.document.getElementById('update-id') as web.HTMLInputElement?;
    final nameInput = web.document.getElementById('update-name') as web.HTMLInputElement?;
    final ageInput = web.document.getElementById('update-age') as web.HTMLInputElement?;
    final majorInput = web.document.getElementById('update-major') as web.HTMLInputElement?;

    if (idInput == null || nameInput == null || ageInput == null || majorInput == null) {
      log('❌ Could not find update input elements');
      return;
    }

    if (idInput.value.isEmpty) {
      log('⚠️ Please enter a student ID to update');
      return;
    }

    final age = ageInput.value.isNotEmpty ? int.tryParse(ageInput.value) : null;
    
    final success = await updateStudent(
      idInput.value,
      name: nameInput.value.isNotEmpty ? nameInput.value : null,
      age: age,
      major: majorInput.value.isNotEmpty ? majorInput.value : null,
    );

    if (success) {
      // Clear form
      idInput.value = '';
      nameInput.value = '';
      ageInput.value = '';
      majorInput.value = '';
    }
    
  } catch (error) {
    log('❌ Error updating student: $error');
  }
}

/// Handle delete student button click
void handleDeleteStudent() async {
  try {
    final deleteInput = web.document.getElementById('delete-id') as web.HTMLInputElement?;
    
    if (deleteInput == null) {
      log('❌ Could not find delete input element');
      return;
    }

    if (deleteInput.value.isEmpty) {
      log('⚠️ Please enter a student ID to delete');
      return;
    }

    await deleteStudent(deleteInput.value);
    deleteInput.value = '';
    
  } catch (error) {
    log('❌ Error deleting student: $error');
  }
}

/// Handle clear all students button click
void handleClearAllStudents() async {
  try {
    final confirmed = web.window.confirm(
      'Are you sure you want to delete ALL students? This cannot be undone.',
    );
    
    if (confirmed) {
      await clearAllStudents();
    }
    
  } catch (error) {
    log('❌ Error clearing all students: $error');
  }
}

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

/// Log message to output div with timestamp
void log(String message) {
  try {
    final timestamp = DateTime.now().toString().substring(11, 19);
    final logMessage = '[$timestamp] $message\n';
    
    // Update the output div
    final currentText = outputDiv.textContent ?? '';
    outputDiv.textContent = currentText + logMessage;
    
    // Scroll to bottom - handle potential scrollTop issues
    try {
      outputDiv.scrollTop = outputDiv.scrollHeight;
    } catch (e) {
      // Ignore scroll errors - some browsers might not support this
    }
    
    // Also log to console
    print(logMessage.trim());
    
  } catch (error) {
    print('Error logging message: $error');
  }
}

/// Update status div with color coding
void updateStatus(String message, String type) {
  try {
    statusDiv.textContent = message;
    statusDiv.className = 'status $type';
  } catch (error) {
    print('Error updating status: $error');
  }
}
