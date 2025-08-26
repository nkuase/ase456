//No Test
Future<void> fetchUserData() async {
  print("1. Starting request...");
  await Future.delayed(Duration(seconds: 3));
  print("2. User data received!");
}

void main() {
  fetchUserData().then((_) => print("3. This waits until awaitbove is done"));
}