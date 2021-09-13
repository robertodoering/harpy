import 'dart:io';

import 'package:args/args.dart';

// ignore_for_file: avoid_print

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
/// dart generate_library_file -p lib/foo/bar --override-existing --excludes
/// .g.dart
/// ```
Future<void> main(List<String> arguments) async {
  final argParser = ArgParser()
    ..addOption('path', abbr: 'p')
    ..addFlag('override-existing')
    ..addFlag('no-format')
    ..addMultiOption('includes', defaultsTo: <String>['.dart'])
    ..addMultiOption('excludes', defaultsTo: <String>[]);

  final argResult = argParser.parse(arguments);

  if (!argResult.wasParsed('path')) {
    throw ArgumentError('must provide a path');
  }

  // arguments
  final String path = argResult['path'];
  final bool? override = argResult['override-existing'];
  final bool noFormat = argResult['no-format'];
  final List<String>? includes = argResult['includes'];
  final List<String>? excludes = argResult['excludes'];

  if (!path.startsWith('lib')) {
    throw ArgumentError(
      'path must be relative to the project root (e.g. lib/foo/bar/)',
    );
  }

  final dir = Directory(path);
  final libraryName = dir.path.split('/').last;
  final libraryFile = File('${dir.path}/$libraryName.dart');

  if (libraryFile.existsSync() && !override!) {
    throw Exception('library file ${libraryFile.path} already exists');
  }

  print('generating library file...');

  final contentBuffer = StringBuffer();

  for (final systemEntry in dir.listSync(recursive: true)) {
    if (systemEntry is File) {
      final entry = systemEntry.path
          .replaceAll(r'\', '/')
          .replaceFirst('${dir.path}/', '');

      if (includes!.any(entry.endsWith) && !excludes!.any(entry.endsWith)) {
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

    final result = await Process.run(
      'dartfmt',
      [
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
