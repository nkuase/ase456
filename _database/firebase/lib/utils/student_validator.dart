/// Input validation utility for Student data
class StudentValidator {
  /// Validate student name
  static bool isValidName(String name) {
    final trimmedName = name.trim();
    return trimmedName.isNotEmpty && 
           trimmedName.length >= 2 && 
           trimmedName.length <= 100 &&
           RegExp(r'^[a-zA-Z\s\-\.\']+$').hasMatch(trimmedName);
  }

  /// Validate student age
  static bool isValidAge(int age) {
    return age >= 16 && age <= 120;
  }

  /// Validate student major
  static bool isValidMajor(String major) {
    final validMajors = [
      'Computer Science',
      'Computer Engineering',
      'Software Engineering',
      'Data Science',
      'Information Technology',
      'Mathematics',
      'Physics',
      'Chemistry',
      'Biology',
      'Engineering',
      'Mechanical Engineering',
      'Electrical Engineering',
      'Civil Engineering',
      'Business Administration',
      'Economics',
      'Psychology',
      'English Literature',
      'Art',
      'Music',
      'Philosophy',
      'History',
      'Political Science',
      'Sociology',
      'Anthropology',
      'Medicine',
      'Nursing',
      'Pharmacy',
      'Law',
      'Education',
      'Architecture',
    ];
    return validMajors.contains(major.trim());
  }

  /// Get list of valid majors
  static List<String> getValidMajors() {
    return [
      'Computer Science',
      'Computer Engineering',
      'Software Engineering',
      'Data Science',
      'Information Technology',
      'Mathematics',
      'Physics',
      'Chemistry',
      'Biology',
      'Engineering',
      'Mechanical Engineering',
      'Electrical Engineering',
      'Civil Engineering',
      'Business Administration',
      'Economics',
      'Psychology',
      'English Literature',
      'Art',
      'Music',
      'Philosophy',
      'History',
      'Political Science',
      'Sociology',
      'Anthropology',
      'Medicine',
      'Nursing',
      'Pharmacy',
      'Law',
      'Education',
      'Architecture',
    ];
  }

  /// Validate name and return error message if invalid
  static String? validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (name.trim().length > 100) {
      return 'Name cannot exceed 100 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s\-\.\']+$').hasMatch(name.trim())) {
      return 'Name can only contain letters, spaces, hyphens, dots, and apostrophes';
    }
    return null; // Valid
  }

  /// Validate age and return error message if invalid
  static String? validateAge(String ageText) {
    if (ageText.trim().isEmpty) {
      return 'Age cannot be empty';
    }
    
    final age = int.tryParse(ageText.trim());
    if (age == null) {
      return 'Age must be a valid number';
    }
    
    if (age < 16) {
      return 'Age must be at least 16';
    }
    if (age > 120) {
      return 'Age cannot exceed 120';
    }
    
    return null; // Valid
  }

  /// Validate major and return error message if invalid
  static String? validateMajor(String major) {
    if (major.trim().isEmpty) {
      return 'Major cannot be empty';
    }
    
    if (!isValidMajor(major)) {
      return 'Please select a valid major from the list';
    }
    
    return null; // Valid
  }

  /// Validate all student fields at once
  static Map<String, String> validateStudent({
    required String name,
    required String ageText,
    required String major,
  }) {
    final errors = <String, String>{};
    
    final nameError = validateName(name);
    if (nameError != null) {
      errors['name'] = nameError;
    }
    
    final ageError = validateAge(ageText);
    if (ageError != null) {
      errors['age'] = ageError;
    }
    
    final majorError = validateMajor(major);
    if (majorError != null) {
      errors['major'] = majorError;
    }
    
    return errors;
  }

  /// Check if student data is completely valid
  static bool isStudentValid({
    required String name,
    required String ageText,
    required String major,
  }) {
    return validateStudent(
      name: name,
      ageText: ageText,
      major: major,
    ).isEmpty;
  }

  /// Sanitize student name (trim and normalize)
  static String sanitizeName(String name) {
    return name.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Sanitize student major (trim and normalize)
  static String sanitizeMajor(String major) {
    return major.trim();
  }

  /// Parse and validate age from string
  static int? parseAge(String ageText) {
    final age = int.tryParse(ageText.trim());
    if (age != null && isValidAge(age)) {
      return age;
    }
    return null;
  }

  /// Get validation rules as a human-readable string
  static String getValidationRules() {
    return '''
Validation Rules:
• Name: 2-100 characters, letters, spaces, hyphens, dots, and apostrophes only
• Age: 16-120 years old
• Major: Must select from the predefined list of majors
    ''';
  }

  /// Get age range description
  static String getAgeRangeDescription() {
    return 'Age must be between 16 and 120 years old';
  }

  /// Get name format description
  static String getNameFormatDescription() {
    return 'Name must be 2-100 characters long and contain only letters, spaces, hyphens, dots, and apostrophes';
  }
}
