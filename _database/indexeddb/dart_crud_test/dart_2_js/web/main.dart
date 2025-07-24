// Simple Dart example to show main() execution
import 'package:web/web.dart' as web;

void main() {
  print('🚀 Main function is executing!');

  // Prove main() runs by modifying the page
  final body = web.document.body;
  if (body != null) {
    final div = web.HTMLDivElement();
    div.textContent = '✅ This was added by main() function!';
    div.style.fontSize = '14px';
    div.style.color = 'green';
    div.style.padding = '20px';
    div.style.border = '2px solid green';
    div.style.margin = '20px';
    div.style.backgroundColor = '#e8f5e8';
    body.appendChild(div);
  }

  // Also show in console
  print('🎉 main() executed successfully');
}
