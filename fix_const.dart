import 'dart:io';

void main() {
  final directory = Directory('lib');
  final files = directory.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  int totalReplaced = 0;

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    // Remove const from TextStyle when context.adaptiveWhite is present
    final textStyleRegex = RegExp(r'const\s+TextStyle\s*\(([^)]*context\.adaptiveWhite[^)]*)\)');
    if (textStyleRegex.hasMatch(content)) {
      content = content.replaceAllMapped(textStyleRegex, (match) {
        return 'TextStyle(\${match.group(1)})';
      });
      changed = true;
    }

    // Remove const from Icon when context.adaptiveWhite is present
    final iconRegex = RegExp(r'const\s+Icon\s*\(([^)]*context\.adaptiveWhite[^)]*)\)');
    if (iconRegex.hasMatch(content)) {
      content = content.replaceAllMapped(iconRegex, (match) {
        return 'Icon(\${match.group(1)})';
      });
      changed = true;
    }

    // Remove const from BorderSide/Border when context.adaptiveWhite is present
    final borderRegex = RegExp(r'const\s+(Border|BorderSide|BoxDecoration)\s*\(([^)]*context\.adaptiveWhite[^)]*)\)');
    if (borderRegex.hasMatch(content)) {
      content = content.replaceAllMapped(borderRegex, (match) {
        return '\${match.group(1)}(\${match.group(2)})';
      });
      changed = true;
    }

    if (changed) {
      file.writeAsStringSync(content);
      totalReplaced++;
      print('Fixed const in \${file.path}');
    }
  }
  
  print('Total files updated: \$totalReplaced');
}
