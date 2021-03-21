import 'dart:io';

import 'package:args/args.dart';

/// Creates a library file that exports all files in the directory and any
/// sub directories.
///
/// Arguments:
/// `-p`, `--path`: Provides the path for the library root.
/// `--override-existing`: Whether the existing library file should be
/// overridden when present.
/// `--no-format`: Whether the library file should not be formatted.
/// `--includes`: A list of file suffixes that should be included.
/// Defaults to `.dart`.
/// `--excludes`: A list of file suffixes that should be excluded.
///
/// Example:
/// ```sh
/// dart generate_library_file -p lib/foo/bar --override-existing --excludes.g.dart
/// ```
Future<void> main(List<String> arguments) async {
  final ArgParser argParser = ArgParser()
    ..addOption('path', abbr: 'p')
    ..addFlag('override-existing')
    ..addFlag('no-format')
    ..addMultiOption('includes', defaultsTo: <String>['.dart'])
    ..addMultiOption('excludes', defaultsTo: <String>[]);

  final ArgResults argResult = argParser.parse(arguments);

  if (!argResult.wasParsed('path')) {
    throw ArgumentError('must provide a path');
  }

  // arguments
  final String path = argResult['path'];
  final bool override = argResult['override-existing'];
  final bool noFormat = argResult['no-format'];
  final List<String> includes = argResult['includes'];
  final List<String> excludes = argResult['excludes'];

  if (!path.startsWith('lib')) {
    throw ArgumentError('path must be relative to the project root '
        '(e.g. lib/foo/bar/)');
  }

  final Directory dir = Directory(path);
  final String libraryName = dir.path.split('/').last;
  final File libraryFile = File('${dir.path}/$libraryName.dart');

  if (libraryFile.existsSync() && !override) {
    throw Exception('library file ${libraryFile.path} already exists');
  }

  print('generating library file...');

  final StringBuffer contentBuffer = StringBuffer();

  for (FileSystemEntity systemEntry in dir.listSync(recursive: true)) {
    if (systemEntry is File) {
      final String entry = systemEntry.path
          .replaceAll('\\', '/')
          .replaceFirst('${dir.path}/', '');

      if (includes.any(entry.endsWith) && !excludes.any(entry.endsWith)) {
        contentBuffer.writeln("export '$entry';");
      }
    }
  }

  libraryFile.writeAsStringSync(
    contentBuffer.toString(),
    flush: true,
  );

  print('created library file ${libraryFile.path}!');

  if (!noFormat) {
    print('formatting...');

    final ProcessResult result = await Process.run(
      'dartfmt',
      <String>[
        '-w',
        '--fix',
        libraryFile.path,
      ],
      runInShell: true,
    );

    if (result.exitCode == 0) {
      print('library file ${libraryFile.path} formatted!');
    }
  }
}
