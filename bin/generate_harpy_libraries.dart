import 'dart:io';

// ignore_for_file: avoid_print

/// Generates the library files for harpy.
Future<void> main() async {
  final paths = [
    'lib/api',
    'lib/components',
    'lib/core',
    'lib/misc',
    'lib/harpy_widgets',
  ];

  for (final path in paths) {
    final result = await Process.run('dart', [
      'bin/generate_library_file.dart',
      '-p',
      path,
      '--override-existing',
      '--excludes',
      '.g.dart,_state.dart,_event.dart',
    ]);

    if (result.exitCode == 0) {
      print(result.stdout);
    } else {
      print(result.stderr);
    }
  }
}
