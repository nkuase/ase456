Future<String> fetchUserOrder() => Future.delayed(
  Duration(seconds: 2),
  () => "Americano",
  ); 
void main() {
  print ('Program started');
  fetchUserOrder()
  .then((order) => print('Order is ready: $order'))
  .catchError((error) => print(error))
  .whenComplete(() => print('Done'));
  print('This message will be printed right away');
}  