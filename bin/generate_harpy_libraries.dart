import 'dart:io';

/// Generates the library files for harpy.
Future<void> main() async {
  final List<String> paths = <String>[
    'lib/api',
    'lib/components',
    'lib/core',
    'lib/misc',
    'lib/harpy_widgets',
  ];

  for (String path in paths) {
    final ProcessResult result = await Process.run('dart', <String>[
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
