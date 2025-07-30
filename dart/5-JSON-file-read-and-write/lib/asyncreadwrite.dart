import 'dart:io';

Future<String> loadConfigAsync(String filePath) async {
  try {
    print('Reading file asynchronously...');

    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('File not found', filePath);
    }
    // This doesn't block other operations!
    final content = await file.readAsString();
    print('File content loaded successfully:\n$content');
    return content;
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

Future<bool> saveConfigAsync(String filePath, String content) async {
  try {
    print('Writing file asynchronously...');
    final file = File(filePath);
    final directory = file.parent;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    // This doesn't block other operations!
    await file.writeAsString(content);
    return true;
  } catch (e) {
    print('Error writing file: $e');
    return false;
  }
}

void main() async {
  // where this script is located
  final scriptPath = Platform.script.toFilePath();
  // get the directory of the script
  final scriptDir = File(scriptPath).parent.path;

  // configPath is in the same directory as this script
  final configPath = '$scriptDir${Platform.pathSeparator}config.txt';

  var success = await saveConfigAsync(configPath, "abc");
  if (success) {
    print('Configuration written successfully.');
  } else {
    print('Failed to write configuration.');
  }

  try {
    String result = await loadConfigAsync(configPath);
    print('Loading configuration from $configPath: content $result');
  } catch (e) {
    print('Error: $e');
  }
}
