import 'dart:io';
import '../api/crud_api_server.dart';
import '../implementations/sqlite_service.dart';
import '../implementations/pocketbase_service.dart';
import '../core/interfaces/database_service.dart';

/// Example of running the CRUD API server with different database backends
/// This shows how to expose any database through a REST API
Future<void> main(List<String> args) async {
  print('🚀 === CRUD API Server Example ===');
  print('Starting REST API server that can work with any database backend...');
  
  // Parse command line arguments
  String databaseType = 'sqlite';
  int port = 8080;
  String host = 'localhost';
  
  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--database':
      case '-d':
        if (i + 1 < args.length) {
          databaseType = args[i + 1];
          i++;
        }
        break;
      case '--port':
      case '-p':
        if (i + 1 < args.length) {
          port = int.tryParse(args[i + 1]) ?? 8080;
          i++;
        }
        break;
      case '--host':
      case '-h':
        if (i + 1 < args.length) {
          host = args[i + 1];
          i++;
        }
        break;
      case '--help':
        printHelp();
        return;
    }
  }
  
  try {
    // Select database service based on type
    final databaseService = createDatabaseService(databaseType);
    
    // Create and start API server
    final apiServer = CrudApiServer(
      databaseService: databaseService,
      port: port,
      host: host,
    );
    
    await apiServer.start();
    
    // Keep server running
    print('');
    print('🌐 Server is running! Try these commands:');
    print('');
    print('# Health check');
    print('curl http://$host:$port/api/health');
    print('');
    print('# Get all students');
    print('curl http://$host:$port/api/students');
    print('');
    print('# Create a student');
    print('curl -X POST http://$host:$port/api/students \\');
    print('  -H "Content-Type: application/json" \\');
    print('  -d \'{"name":"Alice Johnson","age":20,"major":"Computer Science"}\'');
    print('');
    print('# Get database statistics');
    print('curl http://$host:$port/api/stats');
    print('');
    print('Press Ctrl+C to stop the server');
    
    // Wait for interrupt signal
    await waitForInterrupt();
    
    print('\\n🛑 Shutting down server...');
    await apiServer.stop();
    print('✅ Server stopped gracefully');
    
  } catch (e) {
    print('❌ Failed to start server: $e');
    exit(1);
  }
}

/// Create database service based on type
DatabaseService createDatabaseService(String type) {
  switch (type.toLowerCase()) {
    case 'sqlite':
      return SQLiteService();
    case 'pocketbase':
      return PocketBaseService();
    default:
      print('❌ Unknown database type: $type');
      print('Available types: sqlite, pocketbase');
      exit(1);
  }
}

/// Wait for interrupt signal (Ctrl+C)
Future<void> waitForInterrupt() async {
  final ProcessSignal signal = ProcessSignal.sigint;
  await signal.watch().first;
}

/// Print help message
void printHelp() {
  print('Universal CRUD API Server');
  print('');
  print('Usage: dart run lib/examples/api_server_example.dart [OPTIONS]');
  print('');
  print('Options:');
  print('  -d, --database TYPE    Database type (sqlite, pocketbase) [default: sqlite]');
  print('  -p, --port PORT        Server port [default: 8080]');
  print('  -h, --host HOST        Server host [default: localhost]');
  print('  --help                 Show this help message');
  print('');
  print('Examples:');
  print('  dart run lib/examples/api_server_example.dart');
  print('  dart run lib/examples/api_server_example.dart -d sqlite -p 3000');
  print('  dart run lib/examples/api_server_example.dart -d pocketbase -p 8080');
}


