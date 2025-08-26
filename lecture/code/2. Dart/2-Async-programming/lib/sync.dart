import 'dart:io';

//No test
void fetchUserData() {
  print("1. Starting request...");
  sleep(Duration(seconds:3));
  print("2. User data received!");
  print("3. Continue with other tasks");
}

void main() {
  fetchUserData();
  print("4. This waits until above is done");
}