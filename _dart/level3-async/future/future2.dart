Future<String> fetchUserOrder() => Future.delayed(
  Duration(seconds: 2),
  () => "Americano",
  ); 
  
void main() async {
  print ('Program started');
  try {
    final order = await fetchUserOrder();
    print('Order is ready: $order');
  } catch (error) {
    print(error);
  } finally {
    print('Done');
  }
  print('This message will not be printed right away');
}  