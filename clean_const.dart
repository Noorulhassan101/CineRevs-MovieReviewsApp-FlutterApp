import 'dart:io';

void main() {
  final directory = Directory('lib');
  final files = directory.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    List<String> lines = file.readAsLinesSync();
    bool changed = false;

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('context.adaptiveWhite')) {
        // If this line contains adaptiveWhite, check if it or previous lines have 'const'
        // Simplest heuristic: remove 'const ' from the current line if present
        if (lines[i].contains('const ')) {
          lines[i] = lines[i].replaceAll('const ', '');
          changed = true;
        }
        
        // Also check if the previous line starts with 'const' (e.g. const Text() or const Icon())
        if (i > 0 && lines[i-1].trim().startsWith('const ')) {
          lines[i-1] = lines[i-1].replaceFirst('const ', '');
          changed = true;
        }

        // Check if current line starts with 'const'
        if (lines[i].trim().startsWith('const ')) {
           lines[i] = lines[i].replaceFirst('const ', '');
           changed = true;
        }
      }
    }

    if (changed) {
      file.writeAsStringSync(lines.join('\n'));
      print('Cleaned const in ${file.path}');
    }
  }
}
