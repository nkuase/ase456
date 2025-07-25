Future<String> fetchUserOrder() => Future.delayed(
  Duration(seconds: 2),
  () => throw("ERROR!")
  ); 
  
void function() async {
  try {
    final order = await fetchUserOrder();
    print('Order is ready: $order');
  } catch (error) {
    print(error);
  } finally {
    print('Done');
  }
}  
void main() {
  print ('Program started');
  function();
  print('This message will be printed right away - again');
}  