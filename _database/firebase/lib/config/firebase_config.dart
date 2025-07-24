import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration for different environments
class FirebaseConfig {
  /// Get Firebase options based on current environment
  static FirebaseOptions get currentEnvironment {
    const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
    
    switch (environment) {
      case 'prod':
        return _productionOptions;
      case 'staging':
        return _stagingOptions;
      default:
        return _developmentOptions;
    }
  }

  /// Production Firebase configuration
  static const FirebaseOptions _productionOptions = FirebaseOptions(
    apiKey: 'YOUR_PROD_API_KEY',
    authDomain: 'your-project-prod.firebaseapp.com',
    projectId: 'your-project-prod',
    storageBucket: 'your-project-prod.appspot.com',
    messagingSenderId: '123456789012',
    appId: '1:123456789012:web:abcdefg',
    measurementId: 'G-ABCDEFGHIJ',
  );

  /// Staging Firebase configuration
  static const FirebaseOptions _stagingOptions = FirebaseOptions(
    apiKey: 'YOUR_STAGING_API_KEY',
    authDomain: 'your-project-staging.firebaseapp.com',
    projectId: 'your-project-staging',
    storageBucket: 'your-project-staging.appspot.com',
    messagingSenderId: '123456789012',
    appId: '1:123456789012:web:hijklmno',
    measurementId: 'G-KLMNOPQRST',
  );

  /// Development Firebase configuration
  static const FirebaseOptions _developmentOptions = FirebaseOptions(
    apiKey: 'YOUR_DEV_API_KEY',
    authDomain: 'your-project-dev.firebaseapp.com',
    projectId: 'your-project-dev',
    storageBucket: 'your-project-dev.appspot.com',
    messagingSenderId: '123456789012',
    appId: '1:123456789012:web:pqrstuvw',
    measurementId: 'G-UVWXYZABCD',
  );

  /// Initialize Firebase with environment-specific configuration
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: currentEnvironment,
    );
  }

  /// Get current environment name
  static String get environmentName {
    return const String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
  }

  /// Check if running in production
  static bool get isProduction {
    return environmentName == 'prod';
  }

  /// Check if running in staging
  static bool get isStaging {
    return environmentName == 'staging';
  }

  /// Check if running in development
  static bool get isDevelopment {
    return environmentName == 'dev';
  }

  /// Get project ID for current environment
  static String get projectId {
    return currentEnvironment.projectId;
  }

  /// Get storage bucket for current environment
  static String get storageBucket {
    return currentEnvironment.storageBucket ?? '';
  }

  /// Configuration for Firebase emulator (local development)
  static void configureForEmulator() {
    // This should be called after Firebase.initializeApp()
    // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    // FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    // FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }

  /// Settings for different environments
  static Map<String, dynamic> get environmentSettings {
    switch (environmentName) {
      case 'prod':
        return {
          'enableAnalytics': true,
          'enableCrashlytics': true,
          'enablePerformanceMonitoring': true,
          'logLevel': 'error',
          'offlinePersistence': true,
          'cacheSizeBytes': 100 * 1024 * 1024, // 100MB
        };
      case 'staging':
        return {
          'enableAnalytics': true,
          'enableCrashlytics': true,
          'enablePerformanceMonitoring': true,
          'logLevel': 'info',
          'offlinePersistence': true,
          'cacheSizeBytes': 50 * 1024 * 1024, // 50MB
        };
      default: // dev
        return {
          'enableAnalytics': false,
          'enableCrashlytics': false,
          'enablePerformanceMonitoring': false,
          'logLevel': 'debug',
          'offlinePersistence': true,
          'cacheSizeBytes': 20 * 1024 * 1024, // 20MB
        };
    }
  }

  /// Get database URL for current environment
  static String get databaseURL {
    return 'https://${currentEnvironment.projectId}-default-rtdb.firebaseio.com/';
  }

  /// Get authentication domain
  static String get authDomain {
    return currentEnvironment.authDomain ?? '';
  }

  /// Print current configuration (for debugging)
  static void printCurrentConfig() {
    print('=== Firebase Configuration ===');
    print('Environment: $environmentName');
    print('Project ID: ${currentEnvironment.projectId}');
    print('Auth Domain: ${currentEnvironment.authDomain}');
    print('Storage Bucket: ${currentEnvironment.storageBucket}');
    print('Settings: $environmentSettings');
    print('=============================');
  }
}

/// Firebase emulator configuration for testing
class FirebaseEmulatorConfig {
  static const String firestoreHost = 'localhost';
  static const int firestorePort = 8080;
  
  static const String authHost = 'localhost';
  static const int authPort = 9099;
  
  static const String storageHost = 'localhost';
  static const int storagePort = 9199;
  
  static const String functionsHost = 'localhost';
  static const int functionsPort = 5001;

  /// Configure all Firebase services to use emulators
  static void configureAllEmulators() {
    // Firestore emulator
    // FirebaseFirestore.instance.useFirestoreEmulator(firestoreHost, firestorePort);
    
    // Auth emulator
    // FirebaseAuth.instance.useAuthEmulator(authHost, authPort);
    
    // Storage emulator
    // FirebaseStorage.instance.useStorageEmulator(storageHost, storagePort);
    
    // Functions emulator
    // FirebaseFunctions.instance.useFunctionsEmulator(functionsHost, functionsPort);
    
    print('Firebase emulators configured for local development');
  }

  /// Check if emulators are being used
  static bool get isUsingEmulators {
    return const bool.fromEnvironment('USE_FIREBASE_EMULATOR', defaultValue: false);
  }
}
