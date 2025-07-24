import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'config/firebase_config.dart';
import 'widgets/firebase_crud_demo.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Starting Firebase Student App...');
  
  try {
    // Initialize Firebase with environment-specific configuration
    await FirebaseConfig.initialize();
    print('✅ Firebase initialized successfully');
    
    // Print current configuration for debugging
    if (!FirebaseConfig.isProduction) {
      FirebaseConfig.printCurrentConfig();
    }
    
    // Enable offline persistence for better user experience
    await _enableOfflineSupport();
    
    // Configure Firebase emulators if in development
    if (FirebaseConfig.isDevelopment && FirebaseEmulatorConfig.isUsingEmulators) {
      FirebaseEmulatorConfig.configureAllEmulators();
    }
    
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
    print('💡 The app will continue but Firebase features won\'t work');
  }
  
  runApp(const MyApp());
}

/// Enable offline persistence for Firestore
Future<void> _enableOfflineSupport() async {
  try {
    await FirebaseFirestore.instance.enablePersistence();
    print('✅ Offline persistence enabled');
  } catch (e) {
    print('⚠️  Could not enable offline persistence: $e');
    print('💡 This is normal if persistence is already enabled');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Student Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const FirebaseApp(),
    );
  }
}

class FirebaseApp extends StatefulWidget {
  const FirebaseApp({Key? key}) : super(key: key);

  @override
  State<FirebaseApp> createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const FirebaseCrudDemo(),
    const FirebaseStatusPage(),
    const FirebaseExamplesPage(),
  ];

  final List<String> _pageTitles = [
    'Student Management',
    'Firebase Status',
    'Examples & Guides',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'Examples',
          ),
        ],
      ),
    );
  }
}

/// Firebase status and configuration page
class FirebaseStatusPage extends StatefulWidget {
  const FirebaseStatusPage({Key? key}) : super(key: key);

  @override
  State<FirebaseStatusPage> createState() => _FirebaseStatusPageState();
}

class _FirebaseStatusPageState extends State<FirebaseStatusPage> {
  bool _isConnected = false;
  Map<String, dynamic>? _firestoreSettings;

  @override
  void initState() {
    super.initState();
    _checkFirebaseStatus();
  }

  Future<void> _checkFirebaseStatus() async {
    try {
      // Check if Firebase is initialized
      await Firebase.initializeApp();
      
      // Get Firestore settings
      final settings = FirebaseFirestore.instance.settings;
      
      setState(() {
        _isConnected = true;
        _firestoreSettings = {
          'host': settings.host,
          'sslEnabled': settings.sslEnabled,
          'persistenceEnabled': settings.persistenceEnabled,
          'cacheSizeBytes': settings.cacheSizeBytes,
        };
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Status'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConnectionStatus(),
            const SizedBox(height: 16),
            _buildEnvironmentInfo(),
            const SizedBox(height: 16),
            _buildFirestoreSettings(),
            const SizedBox(height: 16),
            _buildCapabilities(),
            const SizedBox(height: 16),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connection Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.error,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected ? 'Connected to Firebase' : 'Not connected',
                  style: TextStyle(
                    color: _isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Environment Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Environment', FirebaseConfig.environmentName.toUpperCase()),
            _buildInfoRow('Project ID', FirebaseConfig.projectId),
            _buildInfoRow('Storage Bucket', FirebaseConfig.storageBucket),
            _buildInfoRow('Auth Domain', FirebaseConfig.authDomain),
            _buildInfoRow('Using Emulators', FirebaseEmulatorConfig.isUsingEmulators ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }

  Widget _buildFirestoreSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firestore Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_firestoreSettings != null) ...[
              _buildInfoRow('Host', _firestoreSettings!['host']?.toString() ?? 'Unknown'),
              _buildInfoRow('SSL Enabled', _firestoreSettings!['sslEnabled']?.toString() ?? 'Unknown'),
              _buildInfoRow('Persistence Enabled', _firestoreSettings!['persistenceEnabled']?.toString() ?? 'Unknown'),
              _buildInfoRow('Cache Size', '${(_firestoreSettings!['cacheSizeBytes'] ?? 0) ~/ (1024 * 1024)} MB'),
            ] else ...[
              const Text('Settings not available'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCapabilities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firebase Capabilities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCapabilityRow('Real-time Updates', true),
            _buildCapabilityRow('Offline Support', true),
            _buildCapabilityRow('Authentication', true),
            _buildCapabilityRow('Cloud Storage', true),
            _buildCapabilityRow('Cloud Functions', true),
            _buildCapabilityRow('Analytics', FirebaseConfig.environmentSettings['enableAnalytics'] ?? false),
            _buildCapabilityRow('Crashlytics', FirebaseConfig.environmentSettings['enableCrashlytics'] ?? false),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _checkFirebaseStatus,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Status'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    FirebaseConfig.printCurrentConfig();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuration printed to console')),
                    );
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Print Config'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance.enableNetwork();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Network enabled')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to enable network: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.wifi),
                  label: const Text('Enable Network'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildCapabilityRow(String capability, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(capability),
        ],
      ),
    );
  }
}

/// Examples and documentation page
class FirebaseExamplesPage extends StatelessWidget {
  const FirebaseExamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examples & Guides'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            'Basic CRUD Operations',
            'Create, Read, Update, Delete operations with Firebase Firestore',
            Icons.storage,
            () => _showExampleDialog(context, 'CRUD Operations', _crudExample),
          ),
          _buildExampleCard(
            'Real-time Streams',
            'Listen to live data changes with Firestore streams',
            Icons.stream,
            () => _showExampleDialog(context, 'Real-time Streams', _streamExample),
          ),
          _buildExampleCard(
            'Query Examples',
            'Advanced querying with where conditions and ordering',
            Icons.search,
            () => _showExampleDialog(context, 'Query Examples', _queryExample),
          ),
          _buildExampleCard(
            'Batch Operations',
            'Perform multiple operations atomically',
            Icons.batch_prediction,
            () => _showExampleDialog(context, 'Batch Operations', _batchExample),
          ),
          _buildExampleCard(
            'Error Handling',
            'Robust error handling with FirebaseResult pattern',
            Icons.error_outline,
            () => _showExampleDialog(context, 'Error Handling', _errorHandlingExample),
          ),
          _buildExampleCard(
            'Offline Support',
            'Working with Firebase offline capabilities',
            Icons.offline_bolt,
            () => _showExampleDialog(context, 'Offline Support', _offlineExample),
          ),
          _buildExampleCard(
            'Security Rules',
            'Firestore security rules examples',
            Icons.security,
            () => _showExampleDialog(context, 'Security Rules', _securityRulesExample),
          ),
          _buildExampleCard(
            'Performance Tips',
            'Best practices for optimal performance',
            Icons.speed,
            () => _showExampleDialog(context, 'Performance Tips', _performanceExample),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String title, String description, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showExampleDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content, style: const TextStyle(fontFamily: 'monospace')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static const String _crudExample = '''
// CREATE
final student = Student(name: 'John Doe', age: 20, major: 'CS');
final result = await studentService.create(student);

// READ
final studentResult = await studentService.read(studentId);

// UPDATE
final updatedStudent = student.copyWith(age: 21);
await studentService.update(studentId, updatedStudent);

// DELETE
await studentService.delete(studentId);
''';

  static const String _streamExample = '''
// Listen to all students in real-time
StreamBuilder<List<Student>>(
  stream: studentService.streamAll(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final students = snapshot.data!;
      return ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index].name),
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
)

// Listen to specific queries
studentService.streamWhere(
  field: 'major',
  value: 'Computer Science',
  operator: '==',
)
''';

  static const String _queryExample = '''
// Find students by major
final csStudents = await studentService.readWhere(
  field: 'major',
  value: 'Computer Science',
  operator: '==',
);

// Find students older than 20
final olderStudents = await studentService.readWhere(
  field: 'age',
  value: 20,
  operator: '>',
  orderBy: 'age',
);

// Get top 10 newest students
final newestStudents = await studentService.readAll(
  orderBy: 'createdAt',
  descending: true,
  limit: 10,
);
''';

  static const String _batchExample = '''
// Create multiple students atomically
final students = [
  Student(name: 'Alice', age: 20, major: 'CS'),
  Student(name: 'Bob', age: 21, major: 'Math'),
  Student(name: 'Carol', age: 19, major: 'Physics'),
];

final result = await studentService.createBatch(students);

result.fold(
  onSuccess: (ids) {
    print('Created \${ids.length} students');
  },
  onError: (error) {
    print('Batch creation failed: \$error');
  },
);
''';

  static const String _errorHandlingExample = '''
// Using FirebaseResult for error handling
final result = await studentService.create(student);

result.fold(
  onSuccess: (id) {
    print('Student created with ID: \$id');
    // Handle success
  },
  onError: (error) {
    print('Creation failed: \$error');
    // Handle error
  },
);

// Chain operations
final chainedResult = result
  .map((id) => 'Created: \$id')
  .flatMap((message) => FirebaseResult.success(message.toUpperCase()));
''';

  static const String _offlineExample = '''
// Enable offline persistence
await FirebaseFirestore.instance.enablePersistence();

// Check if data is from cache
StreamBuilder<List<Student>>(
  stream: studentService.streamAll(),
  builder: (context, snapshot) {
    final isFromCache = snapshot.metadata?.isFromCache ?? false;
    
    return Column(
      children: [
        if (isFromCache)
          Text('Showing cached data (offline)'),
        // ... build your UI
      ],
    );
  },
)

// Monitor sync status
FirebaseFirestore.instance.snapshotsInSync().listen((_) {
  print('Data is synced with server');
});
''';

  static const String _securityRulesExample = '''
// Firestore Security Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Allow authenticated users to read/write students
    match /students/{document} {
      allow read, write: if request.auth != null;
    }
    
    // More granular rules
    match /students/{studentId} {
      // Users can only access their own records
      allow read, write: if request.auth.uid == studentId;
      
      // Validate data on write
      allow create, update: if request.auth != null
        && request.resource.data.age is int
        && request.resource.data.age >= 16
        && request.resource.data.age <= 100;
    }
  }
}
''';

  static const String _performanceExample = '''
// 1. Use server-side filtering instead of client-side
// Bad
final allStudents = await studentService.readAll();
final csStudents = allStudents.where((s) => s.major == 'CS').toList();

// Good
final csStudents = await studentService.readWhere(
  field: 'major',
  value: 'Computer Science',
  operator: '==',
);

// 2. Use pagination for large datasets
final students = await studentService.getDocumentsPaginated(
  limit: 20,
  orderBy: 'name',
);

// 3. Use streams instead of polling
// Bad - polling every second
Timer.periodic(Duration(seconds: 1), (_) async {
  await studentService.readAll();
});

// Good - real-time streams
studentService.streamAll();

// 4. Limit query results
final limitedResults = await studentService.readAll(limit: 50);
''';
}
