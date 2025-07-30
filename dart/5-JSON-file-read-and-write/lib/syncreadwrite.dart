import 'dart:io';

String? loadConfigSync(String filePath) {
  try {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException('File not found', filePath);
    }
    // This blocks until complete!
    final content = file.readAsStringSync();
    print('File content loaded successfully:\n$content');
    return content;
  } catch (e) {
    print('Error loading file: $e');
    return null;
  }
}

bool saveConfigSync(String filePath, String content) {
  try {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException('File not found', filePath);
    }
    // Create directory if it doesn't exist
    final directory = file.parent;
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    // This blocks until the write operation is complete!
    file.writeAsStringSync(content);
    return true;
  } catch (e) {
    print('Error writing file: $e');
    return false;
  }
}

void main() {
  // where this script is located
  final scriptPath = Platform.script.toFilePath();
  // get the directory of the script
  final scriptDir = File(scriptPath).parent.path;

  // configPath is in the same directory as this script
  final configPath = '$scriptDir${Platform.pathSeparator}config.txt';

  try {
    bool result = saveConfigSync(configPath, 'abc');
    print('Loading configuration from $configPath: content $result');
  } catch (e) {
    print('Error: $e');
  }

  try {
    bool success = saveConfigSync(configPath, 'abc');
    if (success) {
      print('Configuration written successfully.');
    } else {
      print('Failed to write configuration.');
    }
  } catch (e) {
    print('Error: $e');
  }
}
