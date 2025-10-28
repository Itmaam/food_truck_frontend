import 'dart:io';
import 'dart:convert';

void main() {
  const projectRoot = 'lib';
  const outputFile = 'lib/localization/l10n/app_en.arb';
  const excludedFolders = [
    'build',
    'api',
    '.dart_tool',
    '.idea',
    'generated',
    'router',
    'localization',
    'ui_helper',
    'test',
  ];

  final dartFiles = _findDartFiles(projectRoot, excludedFolders);
  final strings = _extractStringsFromFiles(dartFiles);
  final arbContent = _generateArbContent(strings);
  File(outputFile).writeAsStringSync(arbContent);
}

Set<String> _findDartFiles(String dir, List<String> excludedFolders) {
  final files = <String>{};
  for (final entity in Directory(dir).listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart') && !_shouldExclude(entity.path, excludedFolders)) {
      files.add(entity.path);
    }
  }
  return files;
}

bool _shouldExclude(String path, List<String> excludedFolders) {
  return excludedFolders.any((folder) => path.contains('/$folder/'));
}

Set<String> _extractStringsFromFiles(Set<String> filePaths) {
  final strings = <String>{};
  final stringRegex = RegExp(r'''(['"])(.*?)(?<!\\)\1''');
  final excludeRegex = RegExp(r'^[0-9]+$|^[A-Z_]+$|^[a-z]+$|^\$[a-zA-Z]');
  final importRegex = RegExp(r'''^\s*import\s+['"].+['"];''');

  for (final path in filePaths) {
    final lines = File(path).readAsLinesSync();

    for (final line in lines) {
      if (importRegex.hasMatch(line)) continue;

      for (final match in stringRegex.allMatches(line)) {
        final text = match.group(2)?.trim() ?? '';
        if (text.length > 1 && !excludeRegex.hasMatch(text) && !text.startsWith('{') && !text.endsWith('}')) {
          strings.add(text);
        }
      }
    }
  }
  return strings;
}

String _generateArbContent(Set<String> strings) {
  final Map<String, dynamic> arb = {'@@locale': 'en', '@@last_modified': DateTime.now().toIso8601String()};

  for (final str in strings) {
    final key = _toKey(str);
    arb[key] = str;
    arb['@$key'] = {'description': 'Auto-extracted from source code'};
  }

  return const JsonEncoder.withIndent('  ').convert(arb);
}

String _toKey(String input) {
  return input
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9 ]'), '') // remove special chars
      .trim()
      .replaceAll(RegExp(r'\s+'), '_'); // spaces to underscores
}
