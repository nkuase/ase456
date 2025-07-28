import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

Map<String, dynamic> generateRandomData() {
  final random = Random();
  
  // Random strings for "foo"
  final fooOptions = ['abc', 'xyz', 'hello', 'world', 'dart', 'firebase'];
  final randomFoo = fooOptions[random.nextInt(fooOptions.length)];
  
  // Random number for "bar" (1-100)
  final randomBar = random.nextInt(100) + 1;
  
  return {
    "foo": randomFoo,
    "bar": randomBar,
    "timestamp": DateTime.now().millisecondsSinceEpoch,
  };
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foobar Firebase Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Foobar Firebase Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // State variables to store foobar data
  String _currentFoo = '';
  int _currentBar = 0;
  String _currentDocId = '';
  bool _isLoading = false;
  String _statusMessage = 'Click the button to generate foobar data!';
  List<Map<String, dynamic>> _dataHistory = [];

  Future<void> _generateAndSaveFoobar() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Generating data...';
    });

    final collectionName = 'foo_flutter_test';
    final firestore = FirebaseFirestore.instance;
    
    try {
      // Step 1: Generate random data
      final newData = generateRandomData();
      print("Generated data: $newData");
      
      setState(() {
        _statusMessage = 'Saving to Firestore...';
      });
      
      // Step 2: Add document to Firestore
      DocumentReference docRef = await firestore
          .collection(collectionName)
          .add(newData);
      
      print("Document added with ID: ${docRef.id}");
      
      // Step 3: Retrieve the saved document to confirm
      DocumentSnapshot docSnapshot = await docRef.get();
      
      if (docSnapshot.exists) {
        Map<String, dynamic> savedData = docSnapshot.data() as Map<String, dynamic>;
        
        // Step 4: Update UI with the new data
        setState(() {
          _currentFoo = savedData['foo'];
          _currentBar = savedData['bar'];
          _currentDocId = docRef.id;
          _statusMessage = 'Data saved successfully!';
          _isLoading = false;
          
          // Add to history (keep last 5 entries)
          _dataHistory.insert(0, {
            'foo': _currentFoo,
            'bar': _currentBar,
            'docId': _currentDocId,
            'timestamp': DateTime.now(),
          });
          
          if (_dataHistory.length > 5) {
            _dataHistory.removeLast();
          }
        });
        
        print("Successfully updated UI with: foo=$_currentFoo, bar=$_currentBar");
      }
      
    } catch (e) {
      print("Error: $e");
      setState(() {
        _statusMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Status Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isLoading ? Icons.sync : Icons.info_outline,
                      size: 32,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _statusMessage,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Current Data Display
            if (_currentFoo.isNotEmpty) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latest Generated Data:',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.label, color: Colors.green.shade600),
                          const SizedBox(width: 8),
                          Text(
                            'foo: ',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '"$_currentFoo"',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.green.shade700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.numbers, color: Colors.green.shade600),
                          const SizedBox(width: 8),
                          Text(
                            'bar: ',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$_currentBar',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.green.shade700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.fingerprint, color: Colors.green.shade600, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Document ID: ',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _currentDocId,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
            
            // History Section
            if (_dataHistory.isNotEmpty) ...[
              Text(
                'Recent History:',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _dataHistory.length,
                  itemBuilder: (context, index) {
                    final data = _dataHistory[index];
                    final timestamp = data['timestamp'] as DateTime;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple.shade100,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.purple.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          'foo: "${data['foo']}" | bar: ${data['bar']}',
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                        subtitle: Text(
                          'Saved: ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Icon(
                          Icons.cloud_done,
                          color: Colors.green.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _generateAndSaveFoobar,
        tooltip: 'Generate Foobar Data',
        icon: _isLoading 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.add),
        label: Text(_isLoading ? 'Saving...' : 'Generate Foobar'),
      ),
    );
  }
}
