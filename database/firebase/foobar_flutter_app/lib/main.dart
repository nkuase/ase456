import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print("🔥 Initializing Firebase...");
    print("Platform: ${defaultTargetPlatform}");
    print("Is Web: $kIsWeb");
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print("✅ Firebase initialized successfully!");
    
    // Test Firestore connection
    print("🔍 Testing Firestore connection...");
    final firestore = FirebaseFirestore.instance;
    
    // Configure Firestore settings for better debugging
    if (!kIsWeb) {
      await firestore.enableNetwork();
      print("✅ Firestore network enabled!");
    }
    
    print("✅ Firestore instance created successfully!");
    
  } catch (e, stackTrace) {
    print("❌ Firebase initialization error: $e");
    print("Stack trace: $stackTrace");
  }
  
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
    "platform": defaultTargetPlatform.toString(),
    "isWeb": kIsWeb,
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
  String _debugInfo = '';

  @override
  void initState() {
    super.initState();
    _updateDebugInfo();
  }

  void _updateDebugInfo() {
    setState(() {
      _debugInfo = '''
Platform: ${defaultTargetPlatform.toString()}
Is Web: $kIsWeb
Firebase Project: foobar-a1317
Collection: foo_flutter_test
      '''.trim();
    });
  }

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
      print("📊 Generated data: $newData");
      
      setState(() {
        _statusMessage = 'Connecting to Firebase...';
      });
      
      // Test network connectivity first
      print("🌐 Testing network connectivity...");
      
      // Add document with timeout to detect hanging requests
      setState(() {
        _statusMessage = 'Saving to Firestore (timeout: 15s)...';
      });
      
      final docRef = await firestore
          .collection(collectionName)
          .add(newData)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Firebase request timed out after 15 seconds.\n'
                'This usually indicates:\n'
                '• Missing network permissions in entitlements\n'
                '• Firewall blocking the connection\n'
                '• Invalid Firebase configuration'
              );
            },
          );
      
      print("✅ Document added with ID: ${docRef.id}");
      
      setState(() {
        _statusMessage = 'Retrieving saved data...';
      });
      
      // Step 3: Retrieve the saved document to confirm
      DocumentSnapshot docSnapshot = await docRef.get().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Document retrieval timed out');
        },
      );
      
      if (docSnapshot.exists) {
        Map<String, dynamic> savedData = docSnapshot.data() as Map<String, dynamic>;
        
        // Update UI with success
        setState(() {
          _currentFoo = savedData['foo'];
          _currentBar = savedData['bar'];
          _currentDocId = docRef.id;
          _statusMessage = '✅ Data saved and retrieved successfully!';
          _isLoading = false;
          
          // Add to history (keep last 5 entries)
          _dataHistory.insert(0, {
            'foo': _currentFoo,
            'bar': _currentBar,
            'docId': _currentDocId,
            'timestamp': DateTime.now(),
            'platform': savedData['platform'] ?? 'unknown',
          });
          
          if (_dataHistory.length > 5) {
            _dataHistory.removeLast();
          }
        });
        
        print("✅ Successfully updated UI with: foo=$_currentFoo, bar=$_currentBar");
      } else {
        throw Exception('Document was created but could not be retrieved');
      }
      
    } catch (e) {
      print("❌ Error details: $e");
      String errorMessage;
      
      if (e.toString().contains('timeout')) {
        errorMessage = '⏱️ Connection timeout\n• Check network permissions in entitlements\n• Verify internet connection';
      } else if (e.toString().contains('permission')) {
        errorMessage = '🔒 Permission denied\n• Check Firebase security rules\n• Verify project configuration';
      } else if (e.toString().contains('network')) {
        errorMessage = '🌐 Network error\n• Check internet connection\n• Verify Firebase configuration';
      } else if (e.toString().contains('not-found')) {
        errorMessage = '📄 Project not found\n• Check Firebase project ID\n• Verify configuration files';
      } else {
        errorMessage = '❌ Error: ${e.toString()}';
      }
      
      setState(() {
        _statusMessage = errorMessage;
        _isLoading = false;
      });
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _statusMessage = 'Testing Firebase connection...';
    });

    try {
      final firestore = FirebaseFirestore.instance;
      
      // Simple read test
      await firestore
          .collection('foo_flutter_test')
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 10));
      
      setState(() {
        _statusMessage = '✅ Connection test successful!';
      });
      
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Connection test failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.network_check),
            onPressed: _testConnection,
            tooltip: 'Test Firebase Connection',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Debug Info Card
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Debug Information',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _debugInfo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
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
                    final platform = data['platform'] as String? ?? 'unknown';
                    
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saved: ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Platform: $platform',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
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
