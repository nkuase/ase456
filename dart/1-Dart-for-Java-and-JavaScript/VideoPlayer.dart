// Lazy Initialization - Video Player Example
// Example from "Dart for Java and JavaScript programmers" lecture

// Simulate heavy operations
String loadHeavyCodec() {
  print('🔄 Loading heavy video codec... (2 seconds)');
  return 'H264Codec';
}

String initAudio() {
  print('🔊 Initializing audio processor... (1 second)');
  return 'AudioProcessor';
}

String allocateBuffer() {
  print('💾 Allocating network buffer... (500ms)');
  return 'NetworkBuffer';
}

// BAD EXAMPLE: Without Lazy Initialization
class VideoPlayerWithoutLazy {
  final String codec = loadHeavyCodec();        // 2 seconds
  final String audio = initAudio();             // 1 second  
  final String buffer = allocateBuffer();       // 500ms
  
  VideoPlayerWithoutLazy() {
    print('✅ VideoPlayerWithoutLazy created');
    // Total: 3.5 seconds startup time!
    // Even if user just wants to check video info
  }
  
  String getVideoInfo() => "Video: 1080p, 60fps"; // Just metadata
  
  void play() {
    print('▶️ Playing video using $codec, $audio, $buffer');
  }
}

// GOOD EXAMPLE: With Lazy Initialization
class VideoPlayerWithLazy {
  late String codec = loadHeavyCodec();      // Only loaded when playing
  late String audio = initAudio();           // Only loaded when audio needed
  late String buffer = allocateBuffer();     // Only loaded when streaming
  
  VideoPlayerWithLazy() {
    print('✅ VideoPlayerWithLazy created instantly!');
  } 
  
  String getVideoInfo() => "Video: 1080p, 60fps"; // No heavy loading
  
  void play() {
    print('▶️ Playing video using $codec, $audio, $buffer');
    // Now the heavy loading happens
  }
  
  void playAudioOnly() {
    print('🎵 Playing audio using $audio');
    // Only audio initialization happens
  }
}

// Another lazy initialization example with final
class ConfigManager {
  late final String databaseUrl = _loadDatabaseConfig();
  late final String apiKey = _loadApiKey();
  late final Map<String, String> settings = _loadSettings();
  
  String _loadDatabaseConfig() {
    print('🗄️ Loading database configuration...');
    return 'postgresql://localhost:5432/mydb';
  }
  
  String _loadApiKey() {
    print('🔑 Loading API key from secure storage...');
    return 'sk-1234567890abcdef';
  }
  
  Map<String, String> _loadSettings() {
    print('⚙️ Loading application settings...');
    return {
      'theme': 'dark',
      'language': 'en',
      'debugMode': 'true',
    };
  }
  
  void connectToDatabase() {
    print('🔗 Connecting to: $databaseUrl');
  }
  
  void makeApiCall() {
    print('🌐 Making API call with key: ${apiKey.substring(0, 8)}...');
  }
  
  void showSettings() {
    print('📋 Current settings: $settings');
  }
}

void demonstrateLazyInitialization() {
  print('=== LAZY INITIALIZATION DEMONSTRATION ===\n');
  
  print('--- WITHOUT Lazy Initialization ---');
  var startTime = DateTime.now();
  var playerWithoutLazy = VideoPlayerWithoutLazy(); // 3.5 second delay
  var endTime = DateTime.now();
  print('🕐 Creation time: ${endTime.difference(startTime).inMilliseconds}ms');
  print('📺 ${playerWithoutLazy.getVideoInfo()}'); // Just wanted metadata!
  
  print('\n--- WITH Lazy Initialization ---');
  startTime = DateTime.now();
  var playerWithLazy = VideoPlayerWithLazy();        // Instant!
  endTime = DateTime.now();
  print('🕐 Creation time: ${endTime.difference(startTime).inMilliseconds}ms');
  print('📺 ${playerWithLazy.getVideoInfo()}');      // Fast!
  
  print('\n--- Now actually using the player ---');
  playerWithLazy.play();                     // Now loads codec & buffer
  
  print('\n--- Audio only example ---');
  var anotherPlayer = VideoPlayerWithLazy();
  anotherPlayer.playAudioOnly();             // Only loads audio
}

void demonstrateConfigManager() {
  print('\n=== CONFIG MANAGER WITH LAZY FINAL ===\n');
  
  var config = ConfigManager();
  print('📦 ConfigManager created instantly!');
  
  print('\n--- Accessing database config ---');
  config.connectToDatabase();  // Loads database config only
  
  print('\n--- Accessing API key ---');
  config.makeApiCall();        // Loads API key only
  
  print('\n--- Accessing settings ---');
  config.showSettings();       // Loads settings only
  
  print('\n--- Accessing database config again ---');
  config.connectToDatabase();  // No loading this time (final + already loaded)
}

// Example showing the difference between late and late final
class LazyComparison {
  late String lazyValue = _computeValue();
  late final String lazyFinalValue = _computeValue();
  
  String _computeValue() {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    print('💻 Computing value at $timestamp');
    return 'Value_$timestamp';
  }
  
  void demonstrateDifference() {
    print('\n--- late String (can be reassigned) ---');
    print('First access: $lazyValue');
    print('Second access: $lazyValue');
    lazyValue = 'Manually set value'; // Can reassign
    print('After manual assignment: $lazyValue');
    
    print('\n--- late final String (computed once, immutable) ---');
    print('First access: $lazyFinalValue');
    print('Second access: $lazyFinalValue'); // Same value
    // lazyFinalValue = 'Cannot assign'; // Compile error!
  }
}

void demonstrateLateVsLateFinal() {
  print('\n=== LATE vs LATE FINAL ===\n');
  
  var comparison = LazyComparison();
  comparison.demonstrateDifference();
}

void main() {
  demonstrateLazyInitialization();
  demonstrateConfigManager();
  demonstrateLateVsLateFinal();
}
