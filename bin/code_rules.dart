// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

final _ignoreDirectionalityRegex = RegExp('// ignore: non_directional');

class _Failure {
  const _Failure(this.path, this.lineNumber, this.message);

  final String path;
  final int lineNumber;
  final String message;
}

final rules = [
  _createRule(
    message: 'Use AlignmentDirectional instead of Alignment.',
    targets: [' Alignment.', ' Alignment('],
  ),
  _createRule(
    message: 'Use EdgeInsetsDirectional.only() instead of EdgeInsets.only().',
    targets: [' EdgeInsets.only'],
  ),
  _createRule(
    message: 'Use EdgeInsetsDirectional.fromSTEB() instead of '
        'EdgeInsets.fromLTRB().',
    targets: [' EdgeInsets.fromLTRB'],
  ),
  _createRule(
    message: 'Use TextAlign.start instead of TextAlign.left.',
    targets: [' TextAlign.left'],
  ),
  _createRule(
    message: 'Use TextAlign.end instead of TextAlign.right.',
    targets: [' TextAlign.right'],
  ),
  _createRule(
    message: 'Use PositionedDirectional instead of Positioned.',
    targets: [' Positioned('],
  ),
];

final _failures = <_Failure>[];

Future<void> main(List<String> args) async {
  print('Running code rules checker...\n');

  await _scanDirectory(Directory('lib'));
  await _scanDirectory(Directory('test'));

  if (_failures.isNotEmpty) {
    final buffer = StringBuffer(
      '''
##########################
# CODE RULE CHECK FAILED #
##########################

''',
    );

    for (final failure in _failures) {
      buffer
        ..writeln(failure.message)
        ..writeln('${failure.path}:${failure.lineNumber}\n');
    }

    print(buffer);

    exit(1);
  }
}

Future<void> _scanDirectory(Directory directory) async {
  await for (final entity in directory.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      await _checkFile(entity);
    }
  }
}

Future<void> _checkFile(File file) async {
  final lines = file.readAsLinesSync();

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];

    if (line.contains(_ignoreDirectionalityRegex)) {
      // ignore this and the next line
      i++;
      continue;
    }

    for (final rule in rules) {
      final result = await rule(line);

      if (result != null) _failures.add(_Failure(file.path, i + 1, result));
    }
  }
}

FutureOr<String?> Function(String line) _createRule({
  required List<Pattern> targets,
  required String message,
}) {
  return (line) {
    if (targets.any((target) => line.contains(target))) {
      return message;
    }

    return null;
  };
}
