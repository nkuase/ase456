Future<String> fetchUserData(int userId) async {
  if (userId > 0) {
    // Success case
    await Future.delayed(Duration(seconds: 1));
    // Future completes with this value
    return "John Doe";
  } else {
    // Failure case
    // Future completes with an error
    throw Exception("Invalid user ID");
  }
}

void main() async {
  try {
    final user = await fetchUserData(123); //   Gets "John Doe"
    print(user);
  } catch (error) {
    print(error.toString()); // Handles any   exception
  }
}