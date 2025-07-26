/// Simple Student model for beginners
/// This represents a student in our system
class Student {
  String name;      // Student's name (like "Alice Johnson")
  int age;          // Student's age (like 20)
  String major;     // What they study (like "Computer Science")
  
  // Constructor - how we create a new student
  Student({
    required this.name,
    required this.age, 
    required this.major,
  });
  
  // Convert student to text for easy reading
  @override
  String toString() {
    return 'Student{name: $name, age: $age, major: $major}';
  }
  
  // Check if two students are the same
  @override
  bool operator ==(Object other) {
    if (other is Student) {
      return name == other.name && age == other.age && major == other.major;
    }
    return false;
  }
  
  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ major.hashCode;
}
